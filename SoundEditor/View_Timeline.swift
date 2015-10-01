//
//  View_Timeline.swift
//  SoundEditor
//
//  Created by David Sklar on 9/26/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit


protocol Protocol_MessagesFromTimeline {
    func soundbiteDidMove(name:String, newStartTime:Float)
}

enum TimelineError: ErrorType {
    case SoundbiteNameInUse
}



class View_Timeline: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    
    
    // Constants
    let channelCount = 8
    let channelPadding : Float = 2
    let timelineWidthInSec = 8 //seconds

    
    // Derived by the geometry
    var secWidthInPx : Float = 0
    var channelHeight : Float = 0 //pixels
    
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
        
        // Gesture recognizer
        let gestureRecog = UIPanGestureRecognizer()
        gestureRecog.addTarget(self, action: "handleSoundbiteDrag:")
        soundbite.addGestureRecognizer(gestureRecog)
        soundbite.userInteractionEnabled = true
    }
    
    func deleteSoundbite(name:String) {
        if let soundbite = dictSoundbites[name] {
            soundbite.removeFromSuperview()
            dictSoundbites.removeValueForKey(name)
        }
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
    
    func handleSoundbiteDrag(sender: UIPanGestureRecognizer) {
        if let sbite = sender.view as? View_SoundBite {
            if curFrameOrigin == nil {
                curFrameOrigin = sbite.frame.origin
            }
            let translation = sender.translationInView(self)
            let currentOrig = curFrameOrigin!
            sbite.frame.origin = CGPointMake(currentOrig.x+translation.x, currentOrig.y)
            if (sender.state == .Ended) {
                curFrameOrigin = nil
                sender.setTranslation(CGPointZero, inView: self)
            }
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
