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
    
        if UserProfile.fontFileURL != nil {
            bookContentView.font = UIFont(name: UserProfile.activeFontName!, size: 30)
        } else {
            bookContentView.font = UIFont(name: (bookContentView.font?.fontName)!, size: 20)
        }
        
        bookContentView.editable = false
        
        print("Path ", UserProfile.booksPaths![bookTitle]!)
//        let url = NSURL(fileURLWithPath: UserProfile.booksPaths![bookTitle]!)
        let url = NSURL(string: UserProfile.booksPaths![bookTitle]!)
        print("url", url)
        do {
            let text = try String(contentsOfURL: url!)
            bookContentView.text = text
        } catch {
            print(error)
        }
    }
}