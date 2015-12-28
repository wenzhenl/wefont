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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookContentView.font = UIFont(name: (bookContentView.font?.fontName)!, size: 20)
        
        if let fontURLs = NSUserDefaults.standardUserDefaults().objectForKey(Settings.keyForFontPathInDefaultUser) {
            if let currentFontName = UserProfile.currentFontName {
                if let _ = fontURLs[currentFontName] as? String {
                     bookContentView.font = UIFont(name: currentFontName, size: 20)
                }
            }
        }
    }
}