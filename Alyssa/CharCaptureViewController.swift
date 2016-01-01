//
//  CharCaptureViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class CharCaptureViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var currentCharContainerView: UIView!
    @IBOutlet weak var currentCharTextField: UITextField! {
        didSet {
            currentCharTextField.delegate = self
        }
    }
    
    var currentChar: String? {
        get {
            return currentCharTextField.text
        }
        set {
            currentCharTextField.text = newValue
        }
    }
    
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var charImageView: UIImageView!
    
    var charImage: UIImage? {
        get {
            return charImageView.image
        }
        set {
            charImageView.image = newValue
        }
    }
    
    @IBOutlet weak var tempImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        
        self.toolbar.tintColor = Settings.ColorOfStamp
        self.currentCharContainerView.backgroundColor = UIColor.clearColor()
        
        self.imageContainerView.backgroundColor = UIColor.clearColor()
        self.charImageView.multipleTouchEnabled = true
        self.charImageView.exclusiveTouch = true
        
        self.view.bringSubviewToFront(toolbar)
        self.view.bringSubviewToFront(currentCharContainerView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let activeChar = UserProfile.activeChar {
            currentChar = activeChar
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UserProfile.activeChar = currentChar
    }
    
    @IBAction func rotateChar(sender: UIRotationGestureRecognizer) {
        
        switch(sender.state) {
        case .Ended: fallthrough
        case .Changed:
            charImageView.transform = CGAffineTransformRotate(charImageView.transform, sender.rotation)
            sender.rotation = 0
        default: break
        }
    }
    
    @IBAction func scaleChar(sender: UIPinchGestureRecognizer) {
       
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            charImageView.transform = CGAffineTransformScale(charImageView.transform, sender.scale, sender.scale)
            sender.scale = 1
        default: break
        }
    }
    
    @IBAction func flipCharColor(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            if let image = charImage {
                charImageView?.image = OpenCV.invertImage(image)
            }
        default: break
        }
    }
    
    @IBAction func moveChar(sender: UIPanGestureRecognizer) {
     
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(charImageView)
            charImageView.transform = CGAffineTransformTranslate(charImageView.transform, translation.x / Settings.GestureScaleForMovingHandwritting, translation.y / Settings.GestureScaleForMovingHandwritting)
            sender.setTranslation(CGPointZero, inView: charImageView)
        default: break
        }
    }
    
    @IBAction func pickImage(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = false
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            picker.allowsEditing = true
            picker.cameraFlashMode = .Off
            picker.showsCameraControls = true
            
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        let opencvImage = OpenCV.magicallyExtractChar(image)
        charImage = opencvImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
