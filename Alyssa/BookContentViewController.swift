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
    
    var bookTitle: String?
    
    var fontName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookContentView.font = UIFont(name: (bookContentView.font?.fontName)!, size: 20)
    }
}
