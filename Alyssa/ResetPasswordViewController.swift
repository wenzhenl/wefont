//
//  ResetPasswordViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/28/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetButtonContainerView: UIView!
    
    
    @IBOutlet weak var textFieldContainerView: FieldContainerView!
    
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            newPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var confirmedNewPasswordTextField: UITextField! {
        didSet {
            confirmedNewPasswordTextField.delegate = self
        }
    }
    
    var userEmail : String!
    var validationCode : String!
    
    var newPassword : String? {
        get {
            return newPasswordTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        set {
            newPasswordTextField.text = newValue
        }
    }
    
    var confirmedNewPassword : String? {
        get {
            return confirmedNewPasswordTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        set {
            confirmedNewPasswordTextField.text = newValue
        }
    }

    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iconImageView.image = UIImage(named: "iTunesArtwork")
        
        resetButtonContainerView.backgroundColor = Settings.ColorOfStamp
        resetButtonContainerView.layer.cornerRadius = 4
        
        textFieldContainerView.backgroundColor = UIColor.clearColor()
        textFieldContainerView.layer.cornerRadius = 4
        textFieldContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textFieldContainerView.layer.borderWidth = 1
    }

    func checkInputs() -> Bool  {
        
        if Settings.isEmpty(userEmail) {
            Settings.popupCustomizedAlert(self, message: "邮箱不能为空")
        } else if !Settings.isValidEmail(userEmail!) {
            Settings.popupCustomizedAlert(self, message: "邮箱地址是无效的")
        } else if Settings.isEmpty(newPassword) {
            Settings.popupCustomizedAlert(self, message: "密码不能为空")
        } else if Settings.isEmpty(confirmedNewPassword) {
            Settings.popupCustomizedAlert(self, message: "请确认密码")
        } else if newPassword != confirmedNewPassword {
            Settings.popupCustomizedAlert(self, message: "确认密码不一致")
        } else if Settings.isEmpty(validationCode) {
            Settings.popupCustomizedAlert(self, message: "验证码不能为空")
        }
        else {
            return true
        }
        return false
    }

    @IBAction func resetPassword() {
        if checkInputs() {
            let params = NSMutableDictionary()
            
            params["email"] = userEmail!
            params["validation_code"] = validationCode
            params["new_password"] = newPassword
            let message = "无网络连接"
            Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIUserResetPassword, params: params, retrivedJSONHandler: handleServerResponse)
        }
    }
    
    func handleServerResponse (json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("reset password success ",  success)
                if let message = parseJSON["message"] as? String {
                    print("reset password message: ", message)
                    
                    if success {
                        Settings.popupCustomizedAlert(self, message: "密码修改成功")
                        
                        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
                        UIApplication.sharedApplication().statusBarStyle = .LightContent
                        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForLoginViewController)
                        appDelegate.window?.rootViewController = initialViewController
                        appDelegate.window?.makeKeyAndVisible()
                    } else {
                        Settings.popupCustomizedAlert(self, message: Settings.decodeErrorCode(message))
                    }
                }
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.confirmedNewPasswordTextField {
            resetPassword()
        }
        
        return true
    }
}
