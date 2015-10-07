//
//  View_SoundBite.swift
//  SoundEditor
//
//  Created by David Sklar on 9/25/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class View_SoundBite: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var handleClippingLeft: UIView!
    @IBOutlet weak var handleClippingRight: UIView!
    
    var name = "Clip"

    @IBOutlet weak var label_Name: UILabel!
    

    // What is the actual current persistent location of this object, i.e. if the user was dragging it somewhere else
    // but then aborted the drag operation, where would this object naturally return to?
    
    var timespec : Timespec?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "View_SoundBite", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        //contentView.layer.borderWidth = 2
        //contentView.layer.borderColor = UIColor(red: 0.8, green:0, blue:0, alpha: 1.0).CGColor
    }
    
    // I wanted to name this "setName" but that is reserved apparently.
    func updateName(name: String) {
        self.name = name
        label_Name.text = name
    }
    
    func moveLeftHandle(pxOffset: CGFloat) -> Bool {
        handleClippingLeft.frame.origin.x = max(0, pxOffset)
        return true
    }
    
}
