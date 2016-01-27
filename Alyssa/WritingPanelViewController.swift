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
    
    // MARK - implement removing noise function
    private var lastPoint = CGPoint.zero
    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var brushWidth: CGFloat = 9.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(tempImageView)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(tempImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
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
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(tempImageView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height))
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, .Square)
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
