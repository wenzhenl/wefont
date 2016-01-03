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
    
    var email : String? {
        get {
            return emailTextField.text
        }
        set {
            emailTextField.text = newValue
        }
    }
    
    var password : String? {
        get {
            return passwordTextField.text
        }
        set {
            passwordTextField.text = newValue
        }
    }
    
    func checkInputs() -> Bool  {
        
        if Settings.isEmpty(email) {
            Settings.popupCustomizedAlert(self, message: "邮箱不能为空")
        } else if !Settings.isValidEmail(email!) {
            Settings.popupCustomizedAlert(self, message: "邮箱地址是无效的")
        } else if Settings.isEmpty(password) {
            Settings.popupCustomizedAlert(self, message: "密码不能为空")
        } else {
            return true
        }
        return false
    }

    @IBAction func login() {
        if checkInputs() {
            let params = NSMutableDictionary()
            
            params["email"] = email!
            params["password"] = password!
            
            let message = "登录失败，请检查网络连接"
            Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIUserSignup, params: params, retrivedJSONHandler: handleServerResponse)
        }
    }
    
    func handleServerResponse (json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("Login success ",  success)
                if let message = parseJSON["message"] as? String {
                    print("Login message: ", message)
                    
                    if success {
                        
                        UserProfile.userEmailAddress = email!
                        UserProfile.userPassword = password!
                        UserProfile.hasLoggedIn = true
                        
                        if let activeFont = parseJSON["active_font"] as? String {
                            UserProfile.activeFontName = activeFont
                        }
                        
                        if let allFontsInfo = parseJSON["all_fonts_info"] as? NSDictionary {
                            UserProfile.fontsNumOfFinishedChars = allFontsInfo as? [String : Int]
                        }
                        
                        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
                        UIApplication.sharedApplication().statusBarStyle = .LightContent
                        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForTabViewController)
                        appDelegate.window?.rootViewController = initialViewController
                        appDelegate.window?.makeKeyAndVisible()
                    } else {
                        Settings.popupCustomizedAlert(self, message: "囧：服务器开小差了")
                    }
                }
            }
        }
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
