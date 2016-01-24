//
//  BookPageContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/1/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class BookPageContentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var bookContentView: UITextView!
    
    var pageIndex: Int!
    
    var chapterContent: String!
    
    var editable: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        bookContentView.delegate = self
        
        if UserProfile.fontFileURL != nil && UserProfile.hasSavedFont {
            bookContentView.font = UIFont(name: UserProfile.activeFontName!, size: 27)
        } else {
            bookContentView.font = UIFont(name: (bookContentView.font?.fontName)!, size: 20)
        }
        
        bookContentView.editable = editable
        
        if bookContentView.editable {
            bookContentView.becomeFirstResponder()
        }
        
        bookContentView.text = chapterContent
    }
    
    override func viewWillLayoutSubviews() {
        bookContentView.setContentOffset(CGPointZero, animated: false)
    }
}
