//
//  CharCaptureViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class CharCaptureViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var uploadBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var imageBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var eraserBarButtonItem: UIBarButtonItem!
    
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
            charImageView.transform = CGAffineTransformIdentity
            charImageView.image = newValue
        }
    }
    
    @IBOutlet weak var tempImageView: UIImageView!
    
    // MARK - Gestures
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    
    @IBOutlet var rotationGesture: UIRotationGestureRecognizer!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var eraserDidSelected = false {
        didSet {
            tapGesture.enabled = !eraserDidSelected
            pinchGesture.enabled = !eraserDidSelected
            rotationGesture.enabled = !eraserDidSelected
            panGesture.enabled = !eraserDidSelected
            
            imageBarButtonItem.enabled = !eraserDidSelected
            cameraBarButtonItem.enabled = !eraserDidSelected
            
            brushSizeSlider.hidden = !eraserDidSelected
            undoBarButtonItem.enabled = eraserDidSelected
            uploadBarButtonItem.enabled = !eraserDidSelected
        }
    }
    
    
    // MARK - erase brush size
    
    @IBOutlet weak var brushSizeSlider: UISlider!
    
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
        
        self.eraserDidSelected = false
        self.brushSizeSlider.hidden = true
        self.brushSizeSlider.minimumValue = Settings.minBrushSize
        self.brushSizeSlider.maximumValue = Settings.maxBrushSize
        self.undoBarButtonItem.title = ""
        self.uploadBarButtonItem.enabled = false
        
        self.view.bringSubviewToFront(toolbar)
        self.view.bringSubviewToFront(currentCharContainerView)
        
        let gridWidth = Settings.WidthOfCharGridView
        let gridAspectRatio = Settings.AspectRatioOfCharGridView
        let gridHeight = gridWidth / gridAspectRatio
        let gridView = CharGridView(frame: CGRectMake(self.view.frame.midX - gridWidth / 2, 0, gridWidth, gridHeight))
        self.imageContainerView.addSubview(gridView)
        self.imageContainerView.bringSubviewToFront(gridView)
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
    
    // MARK - handle all kinds of gestures
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
    
    // MARK - USE touch handling to remove noise
    
    @IBAction func brushSizeChanged(sender: UISlider) {
        brushWidth = CGFloat(sender.value)
    }
    
    var charImageViewOldTransform: CGAffineTransform = CGAffineTransformIdentity
    var footprintsOfCharImage: [UIImage] = []
    
    @IBAction func changeEraserEnableState(sender: UIBarButtonItem) {
        if charImage != nil {
            eraserDidSelected = !eraserDidSelected
            
            if eraserDidSelected {
                charImageViewOldTransform = charImageView.transform
                charImageView.transform = CGAffineTransformIdentity
                eraserBarButtonItem.image = UIImage(named: "lock-locked-selected")
                brushWidth = CGFloat(brushSizeSlider.value)
                undoBarButtonItem.title = "撤销"
                self.title = "去污"
            } else {
                charImageView.transform = charImageViewOldTransform
                eraserBarButtonItem.image = UIImage(named: "lock-locked")
                brushSizeSlider.value = Settings.minBrushSize
                undoBarButtonItem.title = ""
                self.title = "取字"
            }
        }
    }
    
    @IBAction func undoErase(sender: UIBarButtonItem) {
        if eraserDidSelected {
            if footprintsOfCharImage.count > 1 {
                charImage = footprintsOfCharImage.last
                footprintsOfCharImage.removeLast()
            }
            else if footprintsOfCharImage.count == 1 {
                charImage = footprintsOfCharImage.last
            }
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
        if charImage != nil {
            footprintsOfCharImage = [charImage!]
            uploadBarButtonItem.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK - implement removing noise function
    private var lastPoint = CGPoint.zero
    private var red: CGFloat = 1.0
    private var green: CGFloat = 1.0
    private var blue: CGFloat = 1.0
    private var brushWidth: CGFloat = 9.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if eraserDidSelected && charImage != nil {
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.locationInView(tempImageView)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if eraserDidSelected && charImage != nil {
            swiped = true
            if let touch = touches.first {
                let currentPoint = touch.locationInView(tempImageView)
                drawLineFrom(lastPoint, toPoint: currentPoint)
                
                lastPoint = currentPoint
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if eraserDidSelected && charImage != nil {
            if !swiped {
                drawLineFrom(lastPoint, toPoint: lastPoint)
            }
            
            // Merge tempImageView into foregroundImageView
            UIGraphicsBeginImageContextWithOptions(charImageView.frame.size, false, 0.0)
            charImageView.image?.drawInRect(getImageRectForImageView(charImageView), blendMode: .Normal, alpha: 1.0)
            tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: charImageView.frame.size.width, height: charImageView.frame.size.height), blendMode: .Normal, alpha: opacity)
            charImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            footprintsOfCharImage.append(charImage!)
            
            tempImageView.image = nil
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(tempImageView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height))
        print(tempImageView.frame.size.width, tempImageView.frame.size.height)
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, .Square)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, .Normal)
        CGContextSetShouldAntialias(context, false)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    func getImageRectForImageView(imageView: UIImageView) -> CGRect {
        let resVi = imageView.image!.size.width / imageView.image!.size.height
        let resPl = imageView.bounds.size.width / imageView.bounds.size.height
        
        if (resPl > resVi) {
            
            let imageSize = CGSizeMake(imageView.image!.size.width * imageView.bounds.size.height / imageView.image!.size.height, imageView.bounds.size.height)
            return CGRectMake((imageView.bounds.size.width - imageSize.width)/2,
                (imageView.bounds.size.height - imageSize.height)/2,
                imageSize.width,
                imageSize.height)
        } else {
            let imageSize = CGSizeMake(imageView.bounds.size.width, imageView.image!.size.height * imageView.bounds.size.width / imageView.image!.size.width)
            return CGRectMake((imageView.bounds.size.width - imageSize.width)/2,
                (imageView.bounds.size.height - imageSize.height)/2,
                imageSize.width,
                imageSize.height);
        }
    }
}
