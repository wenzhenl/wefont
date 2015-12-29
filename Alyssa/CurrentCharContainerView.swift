//
//  CurrentCharContainerView.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/29/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class CurrentCharContainerView: UIView {

   
    override func drawRect(rect: CGRect) {
         let underScoreLinePath = UIBezierPath()
        underScoreLinePath.moveToPoint(CGPoint(x: self.bounds.width/2 - CGFloat(Settings.widthOfCurrentCharTextFieldNeedingUpdateInStoryboardIfChanged/2), y: self.bounds.height))
        underScoreLinePath.addLineToPoint(CGPoint(x: self.bounds.width/2 + CGFloat(Settings.widthOfCurrentCharTextFieldNeedingUpdateInStoryboardIfChanged/2), y: self.bounds.height))
        Settings.ColorOfStamp.set()
        underScoreLinePath.lineWidth = 2
        underScoreLinePath.stroke()
    }

}
