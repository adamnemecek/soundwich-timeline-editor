//
//  ViewController.swift
//  SoundEditor
//
//  Created by David Sklar on 9/25/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MessagesFromTimelineDelegate {
    
    
    @IBOutlet weak var timeline: TimelineView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! timeline.createSoundbite("1", channelIndex:0, spec: Timespec(start:0, end:3, clipStart:0, clipEnd:3))
        
        try! timeline.createSoundbite("2", channelIndex:1,  spec: Timespec(start:3, end:7.8, clipStart:0, clipEnd:4.8))
        try! timeline.createSoundbite("3", channelIndex:2, spec: Timespec(start:1, end:6, clipStart:2, clipEnd:5))

        
        timeline.registerDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func soundbiteTimespecDidChange(name:String, newSpec:Timespec) {
        
    }
    
    func soundbiteDeleteRequested(name:String) {
    
    }
    
    func soundbiteDuplicateRequested(name:String) {
        
    }
    
    func soundbiteRenameRequested(nameCurrent:String, nameNew:String) {
        
    }



}

