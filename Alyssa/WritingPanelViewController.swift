//
//  WritingPanelViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/27/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class WritingPanelViewController: UIViewController {

    @IBOutlet weak var charImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    @IBAction func cancle() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func trashCharImage(sender: UIBarButtonItem) {
        self.charImageView.image = nil
        self.tempImageView.image = nil
    }
    
    @IBAction func finishedWritingChar() {
        if charImageView.image != nil {
            UserProfile.activeCharImage = charImageView.image
            NSNotificationCenter.defaultCenter().postNotificationName(Settings.NameOfNotificationFinishWritingChar, object: nil, userInfo: nil)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK - implement removing noise function
    private var lastPoint = CGPoint.zero
    private var currentPoint = CGPoint.zero
    private var prevPoint1 = CGPoint.zero
    private var prevPoint2 = CGPoint.zero

    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var brushWidth: CGFloat = 25.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            prevPoint1 = touch.previousLocationInView(tempImageView)
            
            prevPoint2 = touch.previousLocationInView(tempImageView)

            lastPoint = touch.locationInView(tempImageView)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if let touch = touches.first {
            currentPoint = touch.locationInView(tempImageView)
            
            prevPoint2 = prevPoint1
            prevPoint1 = touch.previousLocationInView(tempImageView)
            
            drawCurve()
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Merge tempImageView into foregroundImageView
        UIGraphicsBeginImageContextWithOptions(charImageView.frame.size, false, 0.0)
        charImageView.image?.drawInRect(getImageRectForImageView(charImageView), blendMode: .Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: charImageView.frame.size.width, height: charImageView.frame.size.height), blendMode: .Normal, alpha: opacity)
        charImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        tempImageView.image = nil
    }
    
    
    func drawCurve() {
        UIGraphicsBeginImageContextWithOptions(tempImageView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height))
        
        
        let mid1 = CGPointMake((prevPoint1.x + prevPoint2.x)*0.5, (prevPoint1.y + prevPoint2.y)*0.5)
        
        let mid2 = CGPointMake((currentPoint.x + prevPoint1.x)*0.5, (currentPoint.y + prevPoint1.y)*0.5)
        

        // 2
        CGContextMoveToPoint(context, mid1.x, mid1.y)
        CGContextAddQuadCurveToPoint(context, prevPoint1.x, prevPoint1.y, mid2.x, mid2.y)
        // 3
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, .Normal)
        
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
