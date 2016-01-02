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

    var fontName: String?
    var copyright: String?
    var version: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        textFieldContainerView.backgroundColor = UIColor.clearColor()
        textFieldContainerView.layer.cornerRadius = 4
        textFieldContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textFieldContainerView.layer.borderWidth = 1
        
        fontNameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        startObservingTextFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        stopObservingTextFields()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private var ftfObserver: NSObjectProtocol?
    private var ctfObserver: NSObjectProtocol?
    private var vtfObserver: NSObjectProtocol?
    
    func startObservingTextFields() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        ftfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: fontNameTextField, queue: queue) {
            notification in
            self.fontName = self.fontNameTextField.text
        }
        
        ctfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: copyrightTextField, queue: queue) {
            notification in
            self.copyright = self.copyrightTextField.text
        }
        
        vtfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: versionTextField, queue: queue) {
            notification in
            self.version = self.versionTextField.text
        }
    }
    
    func stopObservingTextFields() {
        if let observer = ftfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
        if let observer = ctfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
        if let observer = vtfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
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
            let params = NSMutableDictionary()
            
            params["email"] = UserProfile.userEmailAddress!
            params["password"] = UserProfile.userPassword!
            params["fontname"] = fontName!
            params["copyright"] = copyright!
            params["version"] = version!
            
            let errInfoForNetwork = "无网络连接"
            Settings.fetchDataFromServer(self, errMsgForNetwork: errInfoForNetwork, destinationURL: Settings.APICreateNewFont, params: params, retrivedJSONHandler: handleResponseFromServer)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func handleResponseFromServer(json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("success: ", success)
                if success == true {
                    Settings.popupCustomizedAlert(self.presentingViewController!, message: "成功创建新字体")
                } else {
                    Settings.popupCustomizedAlert(self.presentingViewController!, message: "不好意思，出错了")
                }
            }
            
        } else {
            print("Cannot fetch Data")
            Settings.popupCustomizedAlert(self.presentingViewController!, message: "不好意思，出错了")
        }
    }
    
    @IBAction func cancle(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
