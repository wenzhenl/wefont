//
//  CharCaptureViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class CharCaptureViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var currentCharContainerView: UIView!
    @IBOutlet weak var currentCharTextField: UITextField! {
        didSet {
            currentCharTextField.delegate = self
        }
    }
    
    var currentChar: String? {
        get {
            return currentCharTextField.text
        }
        set {
            currentCharTextField.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        
        self.toolbar.tintColor = Settings.ColorOfStamp
        self.currentCharContainerView.backgroundColor = UIColor.clearColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
