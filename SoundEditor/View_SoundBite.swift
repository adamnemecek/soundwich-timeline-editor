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
    @IBOutlet weak var leftConstraintForHandleClippingLeft: NSLayoutConstraint!
    
    @IBOutlet weak var handleClippingRight: UIView!
    @IBOutlet weak var leftConstraintForHandleClippingRight: NSLayoutConstraint!
    
    
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
        // Position the right-side clipping handle as its initial "x"
        // is based on the width of the soundbite's frame
        leftConstraintForHandleClippingRight.constant = bounds.width - handleClippingRight.bounds.width
    }
    
    // I wanted to name this "setName" but that is reserved apparently.
    func updateName(name: String) {
        self.name = name
        label_Name.text = name
    }
    
    func moveLeftHandle(deltaX: CGFloat) -> Bool {
        let curX = leftConstraintForHandleClippingLeft.constant
        let minX = CGFloat(0)
        let maxX = leftConstraintForHandleClippingRight.constant
	let newX = min(max(curX+deltaX, minX), maxX)
	if (newX != curX) {
	       leftConstraintForHandleClippingLeft.constant = newX
	       return true
	       }else{
	       return false
}	       
    }
    
}
