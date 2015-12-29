//
//  RecoverPasswordViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/28/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var recoverPasswordButtonContainerView: UIView!
    
    @IBOutlet weak var textFieldContainerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var validationCodeTextField: UITextField! {
        didSet {
            validationCodeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.image = UIImage(named: "iTunesArtwork")
        
        recoverPasswordButtonContainerView.backgroundColor = Settings.ColorOfStamp
        recoverPasswordButtonContainerView.layer.cornerRadius = 4
        
        textFieldContainerView.backgroundColor = UIColor.clearColor()
        textFieldContainerView.layer.cornerRadius = 4
        textFieldContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textFieldContainerView.layer.borderWidth = 1
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func requestValidationCode() {
    }

    @IBAction func recoverPassword() {
    }
}
