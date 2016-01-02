//
//  ThreeFieldContainerView.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/2/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class ThreeFieldContainerView: UIView {

    override func drawRect(rect: CGRect) {
        let middleLinePath = UIBezierPath()
        middleLinePath.moveToPoint(CGPoint(x: 0, y: self.bounds.height/3))
        middleLinePath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height/3))
        middleLinePath.moveToPoint(CGPoint(x: 0, y: self.bounds.height/3*2))
        middleLinePath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height/3*2))
        UIColor.lightGrayColor().set()
        middleLinePath.stroke()
    }
}
