//
//  ViewController.swift
//  SoundEditor
//
//  Created by David Sklar on 9/25/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var soundbite : View_SoundBite!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

