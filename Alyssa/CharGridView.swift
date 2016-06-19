//
//  CharGridView.swift
//  Alyssa
//
//  Created by Wenzheng Li on 10/20/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class CharGridView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var border: CGFloat { return bounds.width * Settings.RatioOfBorderAndWidth }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        
        let color = Settings.CharPickerPrimaryColor
        color.setStroke()
        
        let topLeft = CGPoint(x: self.bounds.minX + border, y: self.bounds.minY + border)
        let topRight = CGPoint(x: self.bounds.maxX - border, y: self.bounds.minY + border)
        let bottomLeft = CGPoint(x: self.bounds.minX + border, y: self.bounds.maxY - border)
        let bottomRight = CGPoint(x: self.bounds.maxX - border, y: self.bounds.maxY - border)
        let topMiddle = CGPoint(x: self.bounds.midX, y: self.bounds.minY + border)
        let bottomMiddle = CGPoint(x: self.bounds.midX, y: self.bounds.maxY - border)
        let leftMiddle = CGPoint(x: self.bounds.minX + border, y: self.bounds.midY)
        let rightMiddle = CGPoint(x: self.bounds.maxX - border, y: self.bounds.midY)
        path.moveToPoint(topLeft)
        path.addLineToPoint(topRight)
        path.addLineToPoint(bottomRight)
        path.addLineToPoint(bottomLeft)
        path.addLineToPoint(topLeft)
        
        path.moveToPoint(topMiddle)
        path.addLineToPoint(bottomMiddle)
        path.moveToPoint(leftMiddle)
        path.addLineToPoint(rightMiddle)
        
        path.stroke()
        
    }
}
