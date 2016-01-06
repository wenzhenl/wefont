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
            return emailTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        set {
            emailTextField.text = newValue
        }
    }
    
    var password : String? {
        get {
            return passwordTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
            Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIUserLogin, params: params, retrivedJSONHandler: handleServerResponse)
            
            Settings.popupCustomizedAlertNotDissmissed(self, message: "正在加载用户信息")
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
                        
                        if let nickname = parseJSON["nickname"] as? String {
                            UserProfile.userNickname = nickname
                            print("nickname: ", nickname)
                        }
                        
                        if let activeFont = parseJSON["active_font"] as? String {
                            print("active font ", activeFont)
                            UserProfile.activeFontName = activeFont
                            dismissViewControllerAnimated(true) {
                                Settings.fetchLatestFont(self, retrivedJSONHandler: self.handleRetrivedFontData)
                                Settings.popupCustomizedAlertNotDissmissed(self, message: "正在加载个人字体")
                            }
                        } else {
                            print("no active font")
                            dismissViewControllerAnimated(true) {
                                let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
                                UIApplication.sharedApplication().statusBarStyle = .LightContent
                                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForTabViewController)
                                appDelegate.window?.rootViewController = initialViewController
                                appDelegate.window?.makeKeyAndVisible()
                            }
                        }
                       
                    } else {
                        dismissViewControllerAnimated(true) {
                            Settings.popupCustomizedAlert(self, message: message)
                        }
                    }
                }
            }
        }
    }

    func handleRetrivedFontData(json: NSDictionary?) {
        if let parseJSON = json {
            // Okay, the parsedJSON is here, let's check if the font is still fresh
            if let success = parseJSON["success"] as? Bool {
                print("Success: \(success)")
                
                if let message = parseJSON["message"] as? String {
                    print("load font ", message)
                    if success {
                        
                        if let fontString = parseJSON["font"] as? String {
                            if let fontData = NSData(base64EncodedString: fontString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                                print("successfully parsed font data")
                                
                                if let lastModifiedTime = parseJSON["last_modified_time"] as? String {
                                    self.saveFontDataToFileSystem(fontData, lastModifiedTime: lastModifiedTime)
                                } else {
                                    print("cannot parse last modified time")
                                }
                            } else {
                                print("Failed convert base64 string to NSData")
                            }
                        } else {
                            print("cannot convert data to String")
                        }
                    }
                } else {
                    print("already the latest font")
                }
            }
        } else {
            print("Cannot fetch data")
        }
        
        dismissViewControllerAnimated(true) {
            let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForTabViewController)
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func saveFontDataToFileSystem(fontData: NSData, lastModifiedTime: String) {
        if let fontFileURL = UserProfile.fontFileURL {
            
            if !fontData.writeToURL(fontFileURL, atomically: true) {
                print("Failed to save font", fontFileURL.absoluteString)
            } else {
                print("Successfully saved font ", fontFileURL.absoluteString)
                UserProfile.updateFontLastModifiedTimeOf(UserProfile.activeFontName!, newTime: lastModifiedTime)
                Settings.updateFont(fontFileURL)
                print("successfully updated font \(UserProfile.activeFontName)")
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
        
        if textField == self.passwordTextField {
            login()
        }
        
        return true
    }
}
