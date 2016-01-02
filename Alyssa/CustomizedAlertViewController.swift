//
//  CustomizedAlertViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/1/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class CustomizedAlertViewController: UIViewController {

    @IBOutlet weak var alertLabel: UILabel!
    
    var message: String! {
        get {
            return alertLabel.text
        }
        set {
            alertLabel.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.4, alpha: 0.7)
        let alertWidth = Settings.WidthOfCustomizedAlertView
        let alertHeight = Settings.HeightOfCustomizedAlertView
        let gridView = UIView(frame: CGRectMake(self.view.frame.midX - alertWidth / 2, self.view.frame.midY - alertHeight / 2, alertWidth, alertHeight))
        gridView.backgroundColor = Settings.ColorOfStamp
        gridView.layer.cornerRadius = 8
        self.view.addSubview(gridView)
        self.view.bringSubviewToFront(alertLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
