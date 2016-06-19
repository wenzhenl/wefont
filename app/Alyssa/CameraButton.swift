//
//  CameraButton.swift
//  Alyssa
//
//  Created by Wenzheng Li on 10/20/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class CameraButton: UIButton {
    override func drawRect(rect: CGRect) {
        
        let innerFilledCircle = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: self.bounds.height/2 * Settings.RatioInnerCircleAndHeightForCameraButton, startAngle: 0, endAngle: 360, clockwise: true)
        
        
        UIColor.blackColor().setFill()
        innerFilledCircle.fill()
        
        
        let outerCircle = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: self.bounds.height/2 * Settings.RatioOuterCircleAndHeightForCameraButton, startAngle: 0, endAngle: 360, clockwise: true)
        UIColor.blackColor().setStroke()
        outerCircle.lineWidth = 3
        outerCircle.stroke()
    }
}
