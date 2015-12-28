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
        if !Reachability.isConnectedToNetwork() {
            
            // Notify users there's error with network
            let alert = UIAlertController(title: "网络连接错误", message: "无法更新个人字体信息，请检查你的网络连接", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            
        } else {
            let url = Settings.ServerIP + Settings.APIFetchingLatestFont
            print(url)
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let params = NSMutableDictionary()
            
            // TODO
            params["fontName"] = UserProfile.currentFontName
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
            }  catch  {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    var err: NSError?
                    var json:NSDictionary?
                    do{
                        json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    }catch{
                        print(error)
                        err = error as NSError
                    }
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(err != nil) {
                        print("Response: \(response)")
                        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Body: \(strData!)")
                        print(err!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    } else {
                        
                        // The JSONObjectWithData constructor didn't return an error. But, we should still
                        // check and make sure that json has a value using optional binding.
                        if let parseJSON = json {
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
                            return
                        }
                        else {
                            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    }
                }
            })
            
            task.resume()
        }
    }
    
       
    func saveFontDataToFileSystem(fontData: NSData) {
        if let fontFilePath = UserProfile.fontFilePath {
            
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(fontFilePath) {
                do {
                    try fileManager.removeItemAtPath(fontFilePath)
                }
                catch {
                    print("Cannot delete font file at ", fontFilePath)
                }
            }
            
            if !fontData.writeToFile(fontFilePath, atomically: true) {
                print("Failed to save font", fontFilePath)
            } else {
                updateFont(fontFilePath)
            }
        }
    }
    
    func updateFont(fontFilePath: String) {
        let fontData: NSData? = NSData(contentsOfFile: fontFilePath)
        if fontData == nil {
            print("Failed to load saved font:", fontFilePath)
        }
        else {
            var error: Unmanaged<CFError>?
            let provider: CGDataProviderRef = CGDataProviderCreateWithCFData(fontData)!
            let font: CGFontRef = CGFontCreateWithDataProvider(provider)!
            
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                print("Failed to register font, error", error)
            } else {
                print("Successfully saved and registered font", fontFilePath)
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
