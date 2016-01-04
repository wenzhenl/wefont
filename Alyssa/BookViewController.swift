//
//  ArticleViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bookTitleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    var books: [String] {
        if UserProfile.userAddedBooks != nil {
            return Settings.defaultSampleBooks + UserProfile.userAddedBooks!
        } else {
            return Settings.defaultSampleBooks
        }
    }
    
    @IBAction func requestNewBook (sender: UIBarButtonItem) {
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self, selector: "requestBookFromServer:", name: "RequestNewBookViewControllerDismissed", object: nil )
        
        let customizedAlertInput = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForAlertInputViewController) as! CustomizedInputAlertViewController
        customizedAlertInput.modalPresentationStyle = .OverFullScreen
        self.presentViewController(customizedAlertInput, animated: true, completion: nil)
    }
    
    func requestBookFromServer (notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "RequestNewBookViewControllerDismissed", object: nil)
        
        if !Settings.isEmpty(UserProfile.requestedBookName) {
            let params = NSMutableDictionary()
            
            params["book_title"] = UserProfile.requestedBookName!
            
            let errInfoForNetwork = "无网络连接"
            Settings.fetchDataFromServer(self, errMsgForNetwork: errInfoForNetwork, destinationURL: Settings.APIFetchBook, params: params, retrivedJSONHandler: handleRetrivedBookData)
        }
    }
    
    func handleRetrivedBookData(json: NSDictionary?) {
        if let parseJSON = json {
            // Okay, the parsedJSON is here, let's check if the font is still fresh
            if let success = parseJSON["success"] as? Bool {
                print("Success: \(success)")
                
                if let message = parseJSON["message"] as? String {
                    print("download book ", message)
                    if success {
                        
                        if let bookString = parseJSON["book"] as? String {
                            if let bookData = NSData(base64EncodedString: bookString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                                print("successfully parsed book data")
                            
                                if let bookTitle = parseJSON["book_title"] as? String {
                                    self.saveBookDataToFileSystem(bookData, bookTitle: bookTitle)
                                    self.bookTitleTableView.reloadData()
                                    UserProfile.requestedBookName = nil
                                    Settings.popupCustomizedAlert(self, message: "成功保存图书")
                                }
                            } else {
                                print("Failed convert base64 string to NSData")
                            }
                        } else {
                            print("cannot convert data to String")
                        }
                    }
                } else {
                    print("cannot find the data")
                    Settings.popupCustomizedAlert(self, message: "没有找到你要的书")
                }
            }
        } else {
            print("Cannot fetch data")
        }
    }

    func saveBookDataToFileSystem(bookData: NSData, bookTitle: String) {
        
        if UserProfile.userAddedBooks != nil {
            UserProfile.userAddedBooks!.append(bookTitle)
        } else {
            UserProfile.userAddedBooks = [bookTitle]
        }
        
        if let bookFileURL = UserProfile.fetchPathOfBook(bookTitle) {
            
            if !bookData.writeToURL(bookFileURL, atomically: true) {
                print("Failed to save book", bookFileURL.absoluteString)
            } else {
                print("Successfully saved book ", bookFileURL.absoluteString)
            }
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForBookTitleCell) as! BookTitleTableViewCell
        cell.selectionStyle = .None
        cell.bookTitleLabel.text = books[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Settings.IdentifierForSegueToBookContent {
                var destination = segue.destinationViewController
                // this next if-statement makes sure the segue prepares properly even
                //   if the MVC we're seguing to is wrapped in a UINavigationController
                if let navCon = destination as? UINavigationController {
                    destination = navCon.visibleViewController!
                }
                if let bcvc = destination as? BookContentViewController {
                    if let bookTitleCell = sender as? BookTitleTableViewCell {
                        bcvc.bookTitle = bookTitleCell.bookTitleLabel.text
                    }
                }
            }
        }
    }
    
}
