//
//  RegisterTextFieldContainerView.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/28/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class RegisterTextFieldContainerView: UIView {

    override func drawRect(rect: CGRect) {
        let middleLinePath = UIBezierPath()
        middleLinePath.moveToPoint(CGPoint(x: 0, y: self.bounds.height/4))
        middleLinePath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height/4))
        middleLinePath.moveToPoint(CGPoint(x: 0, y: self.bounds.height/2))
        middleLinePath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height/2))
        middleLinePath.moveToPoint(CGPoint(x: 0, y: self.bounds.height/4*3))
        middleLinePath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height/4*3))
        UIColor.lightGrayColor().set()
        middleLinePath.stroke()
    }
}
