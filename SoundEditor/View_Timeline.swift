//
//  View_Timeline.swift
//  SoundEditor
//
//  Created by David Sklar on 9/26/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit


protocol MessagesFromTimelineDelegate {
    func soundbiteTimespecDidChange(name:String, newSpec:Timespec)
    func soundbiteDeleteRequested(name:String)
    func soundbiteDuplicateRequested(name:String)
    func soundbiteRenameRequested(nameCurrent:String, nameNew:String)
}


enum TimelineError: ErrorType {
    case SoundbiteNameInUse
    case SoundbiteNameNotFound
}




class View_Timeline: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrubberHairline: UIView!

    // The user should register a delegate callback func to receive
    // messages from the instance of this view:
    var delegate: MessagesFromTimelineDelegate?
    
    // Fixed characteristics
    let channelCount = 8
    let channelPadding : Float = 2
    let timelineWidthInSec = 8 //seconds

    
    // Derived from the fixed characteristics and the geometry
    var secWidthInPx : Float = 0   //width of a second's worth of duration's representation, in pixels
    var channelHeight : Float = 0  //pixels
    
    // Database of soundbites in this timeline
    var dictSoundbites = [String: View_SoundBite]()
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    
    
    
    
    // Public API for populating this timeline with visual representations of "soundbite" objects in
    // the data model.
    
    func registerDelegate(delegate: MessagesFromTimelineDelegate) {
        self.delegate = delegate    
    }
    
    func createSoundbite(name:String, channelIndex:Int, spec:Timespec) throws {
        
        if let _ = dictSoundbites[name] {
            throw TimelineError.SoundbiteNameInUse
        }
        
        let frameRect = CGRectMake(
            CGFloat(spec.start * secWidthInPx),
            CGFloat(((Float(channelIndex)*channelHeight)+channelPadding)),
            CGFloat(spec.duration()*secWidthInPx),
            CGFloat(channelHeight-2*channelPadding))
        
        
        let soundbite = View_SoundBite(frame: frameRect)
        dictSoundbites[name] = soundbite
        addSubview(soundbite)
        soundbite.label_Name.text = name
        
        // Gesture recognizer: drag the soundbite as a whole
        let gestureRecogPan = UIPanGestureRecognizer()
        gestureRecogPan.addTarget(self, action: "handleSoundbiteDrag:")
        soundbite.addGestureRecognizer(gestureRecogPan)
        
        // Gesture recognizer: drag the soundbite clipping handles (L and R)
        let gestureRecogPanHandleLeft = UIPanGestureRecognizer()
        let gestureRecogPanHandleRight = UIPanGestureRecognizer()
        setUpHandleMovementSupport(gestureRecogPanHandleLeft, handle: soundbite.handleClippingLeft)
        setUpHandleMovementSupport(gestureRecogPanHandleRight, handle: soundbite.handleClippingRight)
        
        // Gesture: long-press on soundbite to bring up menu
        let grHold = UILongPressGestureRecognizer()
        grHold.addTarget(self, action: "handleSoundbiteLongPress:")
        soundbite.addGestureRecognizer(grHold)
        
        soundbite.userInteractionEnabled = true
    }
    
    
    
    func deleteSoundbite(name:String) throws {
        if let soundbite = dictSoundbites[name] {
            soundbite.removeFromSuperview()
            dictSoundbites.removeValueForKey(name)
        } else {
            throw TimelineError.SoundbiteNameNotFound
        }
    }
    
    
    // TODO: Animate this!
    func moveScrubberHairline(timeInSeconds: Float) {
        scrubberHairline.frame.origin.x = CGFloat(secWidthInPx * timeInSeconds)
    }

    
    
    
    
    
    // @ TODO
    // Re-derive geometry when the geometry of this (the timeline) changes, e.g. rotate phone.
    
    func initSubviews() {
        // Calculate derived values based on the incoming geometry
        secWidthInPx = Float(bounds.width / CGFloat(timelineWidthInSec))
        channelHeight = Float(Int(bounds.height) / channelCount)
        
        // Instantiate from XIB file
        let nib = UINib(nibName: "Timeline", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    
    // This is non-nil only when a drag is in process:
    var curFrameOrigin : CGPoint?
    var maxAllowedNegativeTranslation : CGFloat?
    var maxAllowedPositiveTranslation : CGFloat?
    
    func handleSoundbiteDrag(sender: UIPanGestureRecognizer) {
        if let sbite = sender.view as? View_SoundBite {
            if curFrameOrigin == nil {
                // This is the start of a drag operation
                self.curFrameOrigin = sbite.frame.origin
                // Determine the limits to the user's ability to drag this left/right
                maxAllowedNegativeTranslation = -1.0 * curFrameOrigin!.x
                maxAllowedPositiveTranslation = self.frame.width - (curFrameOrigin!.x + sbite.frame.width)
            }
            let translation = sender.translationInView(self)
            let currentOrig = curFrameOrigin!
            sbite.frame.origin = CGPointMake(
                currentOrig.x + min(max(translation.x, maxAllowedNegativeTranslation!), maxAllowedPositiveTranslation!),
                currentOrig.y)
            if (sender.state == .Ended) {
                curFrameOrigin = nil
                sender.setTranslation(CGPointZero, inView: self)
                self.reportTimespecChange(sbite)
            }
        }
    }

    
    func handleSoundbiteClipHandleDrag(sender: UIPanGestureRecognizer) {
        if let handle = sender.view {
            if let sb = handle.superview!.superview as? View_SoundBite {
                let translation = sender.translationInView(handle.superview)
                if (sb.moveClippingHandle(handle, deltaX: translation.x)) {
                    sender.setTranslation(CGPointZero, inView: handle.superview!)
                }
                if (sender.state == .Ended) {
                    self.reportTimespecChange(sb)
                }
            }
        }
    }


    
    func reportTimespecChange(sb: View_SoundBite) {
        if let delegate = delegate {
            let newTimespec = Timespec(
                start: Float(sb.frame.origin.x) / secWidthInPx,
                end: Float(sb.frame.origin.x + sb.frame.width) / secWidthInPx,
                clipStart: Float(sb.positionOfLeftClip()) / secWidthInPx,
                clipEnd: Float(sb.positionOfRightClip()) / secWidthInPx
            )
            delegate.soundbiteTimespecDidChange(sb.name, newSpec: newTimespec)
        }
    }
    
    
    func setUpHandleMovementSupport(gest: UIPanGestureRecognizer, handle: UIView) {
        gest.addTarget(self, action: "handleSoundbiteClipHandleDrag:")
        handle.addGestureRecognizer(gest)
        handle.userInteractionEnabled = true
    }
    
    
    
    var sbiteContextOfPopupMenu : View_SoundBite?
    
    func handleSoundbiteLongPress(sender: UILongPressGestureRecognizer) {
        if let sbite = sender.view as? View_SoundBite {
            sbiteContextOfPopupMenu = sbite
            KxMenu.showMenuInView(self, fromRect: sbite.frame, menuItems: [
                KxMenuItem("Rename", image: nil, target: self, action: "pushMenuItem:"),
                KxMenuItem("Duplicate", image: nil, target: self, action: "pushMenuItem:"),
                KxMenuItem("Delete", image: nil, target: self, action: "pushMenuItem:")])
        }
    }
    
    
    func pushMenuItem(sender: KxMenuItem) {
        let commandChosen = sender.title
        switch commandChosen {
        case "Rename":
            return
        case "Delete":
            if let delegate = delegate {
                delegate.soundbiteDeleteRequested(sbiteContextOfPopupMenu!.name)
            }
        default:
            return
        }
    }
    
    
    



    // Internal methods
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 1.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let componentsWhite : [CGFloat] = [1.0, 1.0, 1.0, 1.0]
        let componentsDarkGrey : [CGFloat] = [0.2, 0.2, 0.2, 1.0]

        var color = CGColorCreate(colorSpace, componentsDarkGrey)
        CGContextSetFillColorWithColor(context, color)
        CGContextFillRect(context, rect)
        
        color = CGColorCreate(colorSpace, componentsWhite)
        CGContextSetStrokeColorWithColor(context, color)
        
        for i in 0...channelCount {
            let yCoord = (Float(i) * channelHeight)
            CGContextMoveToPoint(context, 0, CGFloat(yCoord))
            CGContextAddLineToPoint(context, 30000, CGFloat(yCoord))
            CGContextStrokePath(context)
        }
        
    }
    

}
