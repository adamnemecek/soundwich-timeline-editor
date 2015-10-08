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
    var channelIndex : Int?
    var timespec : Timespec?
    var imageForClippedOutPatterning : UIImage?
    
    @IBOutlet weak var label_Name: UILabel!
    
    
    @IBOutlet weak var nameEditorTextField: UITextField!
    
    @IBAction func handleEditingOfNameDidEnd(sender: AnyObject) {
    }
    
    
    

    func startEditingProcess() {
        nameEditorTextField.text = label_Name.text
        nameEditorTextField.hidden = false
        
    }

    
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
    
    func positionOfLeftClip() -> CGFloat {
        // this is normalized so the position being reported is the LEFT edge of the LEFT clipping handle
        return leftConstraintForHandleClippingLeft.constant
    }
    
    func positionOfRightClip() -> CGFloat {
        // this is normalized so the position being reported is the RIGHT edge of the RIGHT clipping handle
        return leftConstraintForHandleClippingRight.constant + handleClippingRight.bounds.width
    }
    
    func moveClippingHandle(whichHandle: UIView, deltaX: CGFloat) -> Bool {
        let handleWidth = whichHandle.bounds.width
        var curX = CGFloat(0)
        var minX = CGFloat(0)
        var maxX = CGFloat(0)
        var whichConstraint : NSLayoutConstraint?
        if (whichHandle == handleClippingLeft) {
            whichConstraint = leftConstraintForHandleClippingLeft
            curX = leftConstraintForHandleClippingLeft.constant
            minX = CGFloat(0)
            maxX = leftConstraintForHandleClippingRight.constant - handleWidth
        } else {
            whichConstraint = leftConstraintForHandleClippingRight
            curX = leftConstraintForHandleClippingRight.constant
            minX = leftConstraintForHandleClippingLeft.constant + handleWidth
            maxX = self.bounds.width - handleWidth
        }
        
        let newX = min(max(curX+deltaX, minX), maxX)
        
        if (newX != curX) {
            whichConstraint!.constant = newX
            return true
	       }else{
            return false
        }
    }
    
}
