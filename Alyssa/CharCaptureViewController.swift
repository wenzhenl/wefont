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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        
        self.toolbar.tintColor = Settings.ColorOfStamp
        self.currentCharContainerView.backgroundColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldEditChanged:", name: "UITextFieldTextDidChangeNotification", object: currentCharTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldEditChanged(notification : NSNotification) {
//        let textField = notification.object as! UITextField
//        let newString = textField.text
//        let lang = textField.textInputMode?.primaryLanguage
//        if lang == "zh-Hans" {
//            let selectedRange = textField.markedTextRange
//            let position = textField.positionFromPosition((selectedRange?.start)!, inDirection: .Left, offset: 0)
//            if position == nil {
//                if newString?.characters.count > 1 {
//                    let index = newString?.endIndex.advancedBy(-1)
//                    textField.text = newString?.substringToIndex(index!)
//                }
//            }
//        } else {
//            if newString?.characters.count > 1 {
//                let index = newString?.endIndex.advancedBy(-1)
//                textField.text = newString?.substringToIndex(index!)
//            }
//        }
//    }
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        let currentCharacterCount = textField.text?.characters.count ?? 0
//        print(currentCharacterCount)
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
//        let newLength = currentCharacterCount + string.characters.count - range.length
//        return newLength <= 1
//    }
}
