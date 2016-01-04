//
//  CustomizedInputAlertViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/4/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class CustomizedInputAlertViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UserProfile.requestedBookName = inputTextField.text
        
        textField.resignFirstResponder()
        
        print("return has been pressed")
        
        NSNotificationCenter.defaultCenter().postNotificationName("RequestNewBookViewControllerDismissed", object: nil, userInfo: nil)
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
        return true
    }
    
}
