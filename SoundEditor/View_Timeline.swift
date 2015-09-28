//
//  View_Timeline.swift
//  SoundEditor
//
//  Created by David Sklar on 9/26/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class View_Timeline: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    
    
        // Constants
    let channelHeight = 24 //pixels
    let channelPadding = 2
    let timelineWidthInSec = 8 //seconds

    
    // Derived by the geometry
    var secWidthInPx : CGFloat = 0
    var channelCount = 1
    
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
    
    
    
    

    func initSubviews() {
        // Calculate derived values based on the incoming geometry
        channelCount = Int(Int(bounds.height) / channelHeight)
        secWidthInPx = bounds.width / CGFloat(timelineWidthInSec)

        // Instantiate from XIB file
        let nib = UINib(nibName: "Timeline", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    
    
    func handleSoundbiteDrag(sender: UIPanGestureRecognizer) {
        if let sbite = sender.view as? View_SoundBite {
            let translation = sender.translationInView(self)
            let currentOrig = sbite.curFrameOrigin!
            sbite.frame.origin = CGPointMake(currentOrig.x+translation.x, currentOrig.y)
            if (sender.state == .Ended) {
                sbite.curFrameOrigin = sbite.frame.origin
                sender.setTranslation(CGPointZero, inView: self)
            }
        }
    }
    
    
    
    // Public API for populating this timeline with visual representations of "sound bites".
    
    func createSoundbite(name:String, channelIndex:Int, startTime:Float, durationInSec:Float) {
        let soundbite = View_SoundBite(frame: CGRectMake(0, CGFloat(((channelIndex*channelHeight)+channelPadding)), (CGFloat(durationInSec)*secWidthInPx), CGFloat(channelHeight-2*channelPadding)))
        dictSoundbites[name] = soundbite
        addSubview(soundbite)
        soundbite.curFrameOrigin = soundbite.frame.origin
        
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



    
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
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
            let yCoord = CGFloat(i * channelHeight)
            CGContextMoveToPoint(context, 0, yCoord)
            CGContextAddLineToPoint(context, 30000, yCoord)
            CGContextStrokePath(context)
        }
        
    }
    

}
