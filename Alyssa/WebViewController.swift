//
//  WebViewController.swift
//  Smashtag
//
//  Created by Wenzheng Li on 9/20/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url: NSURL? {
        didSet {
            if view.window != nil {
                loadURL()
            }
        }
    }
    
    var fittingSize: CGSize!
    
    private func loadURL() {
        if url != nil {
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    @IBAction func savePDFAsImage(sender: AnyObject) {
        let alert = UIAlertController(title: "保存为图片", message: "PDF将会转化为图片保存到相册", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(
            title: "保存",
            style: .Default)
            { (action: UIAlertAction) -> Void in
                self.webView.transform = CGAffineTransformIdentity
                if let image = self.clipImageForRect(CGRect(origin: CGPointZero, size: self.fittingSize), inView: self.webView){
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.scalesPageToFit = true
        loadURL()

        // Do any additional setup after loading the view.
    }

    // MARK: - UIWebView delegate
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(webView: UIWebView) {
        activeDownloads++
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activeDownloads--
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fittingSize
        webView.frame = frame
    }
    
    // MARK - clip a region of view into an image
    func clipImageForRect(clipRect: CGRect, inView: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(clipRect.size, false, CGFloat(1.0))
        let ctx = UIGraphicsGetCurrentContext()
        CGContexgotTranslateCTM(ctx, -clipRect.origin.x, -clipRect.origin.y)
        inView.layer.renderInContext(ctx!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Settings.IdentifierForGoBackFromPDF {
                var destination = segue.destinationViewController
                // this next if-statement makes sure the segue prepares properly even
                //   if the MVC we're seguing to is wrapped in a UINavigationController
                if let navCon = destination as? UINavigationController {
                    destination = navCon.visibleViewController!
                }
                if let _ = destination as? CharPhotoPickerViewController {
                    print("Back to char photo picker")
                }
            }
        }

    }

}
