//
//  ViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 10/13/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit
import MobileCoreServices

class CharPhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // MARK - char image view container
    @IBOutlet weak var charImageViewContainer: UIView!
    
    // MARK - char image
    private var imageView: UIImageView?
    private var charImage: UIImage? {
        get { return imageView?.image }
        set {
            if newValue != nil {
                if imageView != nil {
                    imageView!.removeFromSuperview()
                }
                imageView = UIImageView()
                
                // TODO - the rotation is not sensitive, need to find the reason
                imageView!.backgroundColor = UIColor.clearColor()
                imageView!.multipleTouchEnabled = true
                imageView!.exclusiveTouch = true
                
                imageView!.image = newValue
                charImageViewContainer.addSubview(imageView!)
            }
        }
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var pdfURL: NSURL?
    
    var gridRect: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = self.view.bounds.width
        let gridView = CharGridView(frame: CGRect(x: self.view.bounds.minX, y: self.view.bounds.midY - size/2, width: size, height: size))
        gridRect = CGRect(x: self.view.bounds.minX + gridView.border, y: self.view.bounds.midY - size/2 + gridView.border, width: size - 2*gridView.border, height: size - 2*gridView.border)
        self.view.addSubview(gridView)
        self.view.bringSubviewToFront(charNameTextField)
        self.view.bringSubviewToFront(cameraButton)
    }
    
    @IBAction func rotateChar(sender: UIRotationGestureRecognizer) {
        if let charImageView = imageView {
            switch(sender.state) {
            case .Ended: fallthrough
            case .Changed:
                charImageView.transform = CGAffineTransformRotate(charImageView.transform, sender.rotation)
                sender.rotation = 0
            default: break
            }
        }
    }
    
    @IBAction func scaleChar(sender: UIPinchGestureRecognizer) {
        if let charImageView = imageView {
            switch sender.state {
            case .Ended: fallthrough
            case .Changed:
                charImageView.transform = CGAffineTransformScale(charImageView.transform, sender.scale, sender.scale)
                sender.scale = 1
            default: break
            }
        }
    }
    
    @IBAction func flipCharColor(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            if let image = charImage {
                imageView?.image = OpenCV.invertImage(image)
            }
        default: break
        }
    }
    private struct GestureScaleConstants {
        static let CharGestureScale: CGFloat = 2
    }
    
    @IBAction func moveChar(sender: UIPanGestureRecognizer) {
        if let charImageView = imageView {
            switch sender.state {
            case .Ended: fallthrough
            case .Changed:
                let translation = sender.translationInView(imageView)
                charImageView.transform = CGAffineTransformTranslate(charImageView.transform, translation.x / GestureScaleConstants.CharGestureScale, translation.y / GestureScaleConstants.CharGestureScale)
                sender.setTranslation(CGPointZero, inView: charImageView)
            default: break
            }
        }
    }
   
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK - char text
    @IBOutlet weak var charNameTextField: UITextField! {
        didSet {
            charNameTextField.delegate = self
            charNameTextField.textColor = Settings.CharPickerPrimaryColor
        }
    }
    
    var charWritten: String? {
        get {
            return charNameTextField.text
        }
        set {
            charNameTextField.text = newValue
        }
    }

    
    @IBAction func takePhoto() {
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
        makeRoomForImage()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAndSend() {
        if charImage != nil {
            let charRect = self.view.convertRect(gridRect, toView: charImageViewContainer)
            let image = clipImageForRect(charRect, inView: charImageViewContainer)
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

            if !Reachability.isConnectedToNetwork() {
                
                // Notify users there's error with network
                let alert = UIAlertController(title: "传输错误", message: "图片无法发送，请确保你处于联网状态。", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
                let delay = 3.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })

            } else {
    //            This is my amazon EC2 IP
                let url = "http://52.69.160.113/bmp2vector.php"
                let request = NSMutableURLRequest(URL: NSURL(string: url)!)
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                
                
                let imageData = UIImageJPEGRepresentation(image!, 0.9)
                let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
                print(base64String)
                let params = NSMutableDictionary()
                params["image"] = [ "content_type": "image/jpeg", "filename":"test.jpg", "file_data": base64String]
                
                do{
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
                }catch{
                    print(error)
                }
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        var err: NSError?
                        var json:NSDictionary?
                        do{
                           json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as? NSDictionary
                        }catch{
                            print(error)
                            err = error as NSError
                        }
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        if(err != nil) {
                            print("Response: \(response)")
                            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Body: \(strData!)")
                            print(err!.localizedDescription)
                            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Error could not parse JSON: '\(jsonStr)'")
                            
                        } else {
                            
                            // The JSONObjectWithData constructor didn't return an error. But, we should still
                            // check and make sure that json has a value using optional binding.
                            if let parseJSON = json {
                                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                                if let success = parseJSON["success"] as? Bool {
                                    print("Success: \(success)")
                                    if let returnedURL = parseJSON["url"] as? String {
                                        print("URL: \(returnedURL)")
                                        self.pdfURL = NSURL(string: returnedURL)
                                        self.performSegueWithIdentifier(Settings.IdentifierForPDF, sender: nil)
                                    }
                                }
                                return
                            }
                            else {
                                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                print("Error could not parse JSON: \(jsonStr)")
                            }
                        }
                    }
                })
                
                task.resume()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Settings.IdentifierForPDF {
                var destination = segue.destinationViewController
                // this next if-statement makes sure the segue prepares properly even
                //   if the MVC we're seguing to is wrapped in a UINavigationController
                if let navCon = destination as? UINavigationController {
                    destination = navCon.visibleViewController!
                }
                if let pdfvc = destination as? WebViewController {
                    pdfvc.url = pdfURL
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func makeRoomForImage() {
        if let charImageView = imageView {
            var extraHeight: CGFloat = 0
            if charImageView.image?.aspectRatio > 0 {
                if let width = charImageView.superview?.frame.size.width {
                    let height = width / charImageView.image!.aspectRatio
                    extraHeight = height - charImageView.frame.height
                    charImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                }
            } else {
                extraHeight = -charImageView.frame.height
                charImageView.frame = CGRectZero
            }
            preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
        }
    }
    
    // MARK - clip a region of view into an image
    func clipImageForRect(clipRect: CGRect, inView: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(clipRect.size, false, CGFloat(1.0))
        let ctx = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(ctx, -clipRect.origin.x, -clipRect.origin.y)
        inView.layer.renderInContext(ctx!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}