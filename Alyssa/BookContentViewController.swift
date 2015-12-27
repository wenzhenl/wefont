//
//  BookContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/26/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class BookContentViewController: UIViewController {

    @IBOutlet weak var bookContentView: UITextView!
    
    var bookTitle: String!
    
    var fontFileURL: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontData: NSData? = NSData(contentsOfURL: fontFileURL)
        if fontData == nil {
            print("Failed to load saved font:", fontFileURL.absoluteString)
        }
        else {
            var error: Unmanaged<CFError>?
            let provider: CGDataProviderRef = CGDataProviderCreateWithCFData(fontData)!
            let font: CGFontRef = CGFontCreateWithDataProvider(provider)!
            
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                print("Failed to register font, error", error)
            } else {
                bookContentView.font = UIFont(name: "FZJingLeiS-R-GB", size: 20)
                print("Successfully saved and registered font", fontFileURL.absoluteString)
            }
        }
    }
}
