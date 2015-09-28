//
//  View_Timeline.swift
//  SoundEditor
//
//  Created by David Sklar on 9/26/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class View_Timeline: UIView {
    
    @IBOutlet var contentView: UIView!
    
    
    // Constants
    let channelHeight = 24 //pixels
    let channelPadding = 2
    let timelineWidthInSec = 8 //seconds

    
    // Derived by the geometry
    var secWidthInPx : CGFloat = 0
    var channelCount = 1
    
    
    
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
    
    
    
    func createSoundbite(channelIndex:Int, startTime:Float, durationInSec:Float) {
        let soundbite = View_SoundBite(frame: CGRectMake(0, CGFloat(((channelIndex*channelHeight)+channelPadding)), (CGFloat(durationInSec)*secWidthInPx), CGFloat(channelHeight-2*channelPadding)))
        addSubview(soundbite)
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
