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
    
    var books: [String] = ["小王子", "红楼梦"]
    
    @IBAction func updateMyFont(sender: UIBarButtonItem) {
        fetchLatestFont()
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func fetchLatestFont() {
        
        let params = NSMutableDictionary()
        
        // TODO
        params["fontName"] = UserProfile.currentFontName
        
        let errInfoForNetwork = "无法更新个人字体信息，请检查你的网络连接"
        
        Settings.fetchDataFromServer(self, errMsgForNetwork: errInfoForNetwork, destinationURL: Settings.APIFetchingLatestFont, params: params)
        if let parseJSON = Settings.returnedJSON {
            
            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
            if let fresh = parseJSON["fresh"] as? Bool {
                print("Fresh: \(fresh)")
                
                if !fresh {
                    
                    if let fontString = parseJSON["font"] as? String {
                        if let fontData = NSData(base64EncodedString: fontString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                            self.saveFontDataToFileSystem(fontData)
                        } else {
                            print("Failed convert base64 string to NSData")
                        }
                    } else {
                        print("cannot convert data to String")
                    }
                }
            }
        } else {
            print("Cannot fetch data")
        }
    }
    
       
    func saveFontDataToFileSystem(fontData: NSData) {
        if let fontFileURL = UserProfile.fontFileURL {
            
            let fileManager = NSFileManager.defaultManager()
            let fontFilePath = fontFileURL.path
            if fileManager.fileExistsAtPath(fontFilePath!) {
                do {
                    try fileManager.removeItemAtPath(fontFilePath!)
                    print("Successfully deleted existing font file")
                }
                catch {
                    print("Cannot delete font file at ", fontFilePath)
                }
            } else {
                print("No existing font file")
            }
            
            if !fontData.writeToURL(fontFileURL, atomically: true) {
                print("Failed to save font", fontFilePath)
            } else {
                updateFont(fontFileURL)
            }
        }
    }
    
    func updateFont(fontFileURL: NSURL) {
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
                print("Successfully saved and registered font", fontFileURL.absoluteString)
            }
        }
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
//                    bcvc.fontFileURL = self.fontFileURL
                }
            }
        }
    }
    
}
