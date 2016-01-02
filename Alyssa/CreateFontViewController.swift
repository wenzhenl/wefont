//
//  CreateFontViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/2/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class CreateFontViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldContainerView: ThreeFieldContainerView!
    @IBOutlet weak var fontNameTextField: UITextField! { didSet { fontNameTextField.delegate = self } }
    @IBOutlet weak var copyrightTextField: UITextField! { didSet { copyrightTextField.delegate = self } }
    @IBOutlet weak var versionTextField: UITextField! { didSet { versionTextField.delegate = self } }

    var fontName: String? {
        get {
            return fontNameTextField.text
        }
        set {
            fontNameTextField.text = newValue
        }
    }
    
    var copyright: String? {
        get {
            return copyrightTextField.text
        }
        set {
            copyrightTextField.text = newValue
        }
    }
    
    var version: String? {
        get {
            return versionTextField.text
        }
        set {
            versionTextField.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        textFieldContainerView.backgroundColor = UIColor.clearColor()
        textFieldContainerView.layer.cornerRadius = 4
        textFieldContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textFieldContainerView.layer.borderWidth = 1
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func isEmpty(string: String?) -> Bool {
        if string == nil {
            return true
        }
        if string?.rangeOfString(Settings.patternForEmptyString, options: .RegularExpressionSearch) != nil {
            return true
        }
        return false
    }
    
    func checkInputs() -> Bool  {
        
        if isEmpty(fontName) {
            Settings.popupCustomizedAlert(self, message: "字体名不能为空")
        } else if isEmpty(copyright) {
            Settings.popupCustomizedAlert(self, message: "版权信息不能为空")
        } else if isEmpty(version) {
            Settings.popupCustomizedAlert(self, message: "版本号不能为空")
        } else {
            return true
        }
        return false
    }
    
    @IBAction func createFont(sender: UIBarButtonItem) {
        
        if checkInputs() {
            UserProfile.newFontReadyTosend = true
            UserProfile.newFontName = fontName
            UserProfile.copyright = copyright
            UserProfile.version = version
            NSNotificationCenter.defaultCenter().postNotificationName("CreateViewControllerDismissed", object: nil, userInfo: nil)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancle(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
