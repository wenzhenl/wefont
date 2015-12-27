//
//  ArticleViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    var books: [String] = ["小王子"]
    
    @IBAction func addBook(sender: UIBarButtonItem) {
//        let file = "file.txt"
//        
//        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
//            let dir = dirs[0] //documents directory
//            let path = dir.stringByAppendingPathComponent(file);
//            let text = "some text"
//            
//            //writing
//            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
//            
//            //reading
//            let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
//        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForBookTitleCell) as! BookTitleTableViewCell
        cell.bookTitleLabel.text = books[indexPath.row]
        return cell
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "图书列表"
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        return 50
//        return UITableViewAutomaticDimension
    }
}
