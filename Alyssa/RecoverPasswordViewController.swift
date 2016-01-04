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
    
    var email : String? {
        get {
            return emailTextField.text
        }
        set {
            emailTextField.text = newValue
        }
    }
    
    var validationCode : String? {
        get {
            return validationCodeTextField.text
        }
        set {
            validationCodeTextField.text = newValue
        }
    }
    
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
        
        if textField == self.validationCodeTextField {
            recoverPassword()
        }
        
        return true
    }
    
    @IBAction func requestValidationCode() {
        if !Settings.isEmpty(email) {
            if Settings.isValidEmail(email!) {
                let params = NSMutableDictionary()
                
                params["email"] = email!
                
                let message = "无网络连接"
                Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIUserRequestValidationCode, params: params, retrivedJSONHandler: handleRequestValidationCodeResponse)
            } else {
                Settings.popupCustomizedAlert(self, message: "请提供有效的邮箱地址")
            }
        } else {
            Settings.popupCustomizedAlert(self, message: "邮箱地址不能为空")
        }
    }

    func handleRequestValidationCodeResponse (json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("request validation code success ",  success)
                if let message = parseJSON["message"] as? String {
                    print("request validation message: ", message)
                    
                    if success {
                        Settings.popupCustomizedAlert(self, message: "验证码已经发送到邮箱")
                    } else {
                        Settings.popupCustomizedAlert(self, message: message)
                    }
                }
            }
        }
    }

    @IBAction func recoverPassword() {
        if !Settings.isEmpty(email) {
            if Settings.isValidEmail(email!) {
                if !Settings.isEmpty(validationCode) {
                    let params = NSMutableDictionary()
                    
                    params["email"] = email!
                    params["validation_code"] = validationCode!
                    
                    let message = "无网络连接"
                    Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIConfirmValidationCode, params: params, retrivedJSONHandler: handleConfirmValidationCodeResponse)
                } else {
                    Settings.popupCustomizedAlert(self, message: "请输入你获取的验证码")
                }
            } else {
                Settings.popupCustomizedAlert(self, message: "请提供有效的邮箱地址")
            }
        } else {
            Settings.popupCustomizedAlert(self, message: "邮箱地址不能为空")
        }
    }
    
    func handleConfirmValidationCodeResponse (json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("confirm validation code success ",  success)
                if let message = parseJSON["message"] as? String {
                    print("confirm validation message: ", message)
                    
                    if success {
                        performSegueWithIdentifier(Settings.IdentifierForSegueToNextStepResetPassword, sender: self)
                    } else {
                        Settings.popupCustomizedAlert(self, message: message)
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Settings.IdentifierForSegueToNextStepResetPassword {
                var destination = segue.destinationViewController
                // this next if-statement makes sure the segue prepares properly even
                //   if the MVC we're seguing to is wrapped in a UINavigationController
                if let navCon = destination as? UINavigationController {
                    destination = navCon.visibleViewController!
                }
                if let revc = destination as? ResetPasswordViewController {
                    revc.userEmail = email
                    revc.validationCode = validationCode
                }
            }
        }
    }

}
