//
//  LoginViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/28/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var loginButtonContainerView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var textFieldContainerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var joinAlyssaButton: UIButton!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    
    @IBAction func login() {
        
        UserProfile.hasLoggedIn = true
        
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForTabViewController)
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]

        iconImageView.image = UIImage(named: "iTunesArtwork")
        
        loginButtonContainerView.backgroundColor = Settings.ColorOfStamp
        loginButtonContainerView.layer.cornerRadius = 4
        
        textFieldContainerView.backgroundColor = UIColor.clearColor()
        textFieldContainerView.layer.cornerRadius = 4
        textFieldContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textFieldContainerView.layer.borderWidth = 1
        
        recoverPasswordButton.titleLabel?.textAlignment = .Center
        joinAlyssaButton.titleLabel?.textAlignment = .Center
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
