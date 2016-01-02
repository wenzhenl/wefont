//
//  CustomizedAlertViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/1/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class CustomizedAlertViewController: UIViewController {
    
    var message: String! = "Please haha"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let alertWidth = Settings.WidthOfCustomizedAlertView
        let alertHeight = Settings.HeightOfCustomizedAlertView
        let verticalOffset = Settings.VerticalOffsetOfCustomizedAlertView
        let gridView = UIView(frame: CGRectMake(self.view.frame.midX - alertWidth / 2, self.view.frame.minY + verticalOffset, alertWidth, alertHeight))
        gridView.backgroundColor = Settings.ColorOfAlertView
        gridView.layer.cornerRadius = Settings.HeightOfCustomizedAlertView / 2
        
        let messageLabel = UILabel(frame: CGRectMake(0, 0, alertWidth, alertHeight))
        messageLabel.textAlignment = .Center
        messageLabel.text = message
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.backgroundColor = UIColor.clearColor()
        gridView.addSubview(messageLabel)
        
        self.view.addSubview(gridView)
    }
}
