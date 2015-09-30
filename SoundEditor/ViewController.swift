//
//  ViewController.swift
//  SoundEditor
//
//  Created by David Sklar on 9/25/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var timeline: View_Timeline!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! timeline.createSoundbite("Clip 1", channelIndex:0, startTime:0, durationInSec:5)
        try! timeline.createSoundbite("Clip 2", channelIndex:1, startTime:1, durationInSec:3)
        
        
        // *** THIS WOULD BE HOW I WOULD DO PROGRAMMATIC CREATION OF CUSTVIEW CHILDREN.
        // BUT IT IS NOT NECESSARY TO DO THIS IF YOU INSTANTIATE VIA STORYBOARD.
        
        // we'd probably want to set up constraints here in a real app
        //soundbite = View_SoundBite(frame: CGRectMake(0, 20, view.bounds.width, 200))
        //soundbite.image = UIImage(named: "codepath_logo")
        //.caption = "CodePath starts new class for designers"
        //view.addSubview(soundbite)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

