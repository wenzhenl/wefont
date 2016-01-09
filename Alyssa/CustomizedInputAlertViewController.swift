//
//  CustomizedInputAlertViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/4/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class CustomizedInputAlertViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = Settings.ColorOfStamp
    }
    
    @IBAction func cancle() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirm() {
        UserProfile.requestedBookName = inputTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        NSNotificationCenter.defaultCenter().postNotificationName("RequestNewBookViewControllerDismissed", object: nil, userInfo: nil)
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        print("return has been pressed")
        
             return true
    }
    
}
