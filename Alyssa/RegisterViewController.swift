//
//  RegisterViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/28/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var joinButtonContainerView: UIView!
    
    @IBOutlet weak var textFieldContainerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var confirmedPasswordTextField: UITextField! {
        didSet {
            confirmedPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var nickNameTextField: UITextField! {
        didSet {
            nickNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var nickname : String? {
        get {
            return nickNameTextField.text
        }
        set {
            nickNameTextField.text = newValue
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
    
    var confirmedPassword : String? {
        get {
            return confirmedPasswordTextField.text
        }
        set {
            confirmedPasswordTextField.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinButtonContainerView.backgroundColor = Settings.ColorOfStamp
        joinButtonContainerView.layer.cornerRadius = 4
        
        textFieldContainerView.backgroundColor = UIColor.clearColor()
        textFieldContainerView.layer.cornerRadius = 4
        textFieldContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textFieldContainerView.layer.borderWidth = 1
        
        iconImageView.image = UIImage(named: "iTunesArtwork")
    }

    func checkInputs() -> Bool  {
        
        if Settings.isEmpty(email) {
            Settings.popupCustomizedAlert(self, message: "邮箱不能为空")
        } else if !Settings.isValidEmail(email!) {
            Settings.popupCustomizedAlert(self, message: "邮箱地址是无效的")
        } else if Settings.isEmpty(password) {
            Settings.popupCustomizedAlert(self, message: "密码不能为空")
        } else if Settings.isEmpty(confirmedPassword) {
            Settings.popupCustomizedAlert(self, message: "请确认密码")
        } else if Settings.isEmpty(nickname) {
          Settings.popupCustomizedAlert(self, message: "昵称不能为空")
        } else if password != confirmedPassword {
            Settings.popupCustomizedAlert(self, message: "确认密码不一致")
        } else {
            return true
        }
        return false
    }

    @IBAction func joinAlyssa() {
        if checkInputs() {
            let params = NSMutableDictionary()
            
            params["email"] = email!
            params["password"] = password!
            params["nickname"] = nickname!
            
            let message = "注册失败，请检查网络连接"
            Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIUserSignup, params: params, retrivedJSONHandler: handleServerResponse)
        }
    }
    
    func handleServerResponse (json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("Signup success ",  success)
                if let message = parseJSON["message"] as? String {
                    print("Signup message: ", message)
                    
                    if success {
                        Settings.popupCustomizedAlert(self, message: "注册成功，欢迎加入Alyssa")
                        
                        UserProfile.userEmailAddress = email!
                        UserProfile.userNickname = nickname!
                        UserProfile.userPassword = password!
                        UserProfile.hasLoggedIn = true
                        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
