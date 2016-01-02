//
//  MeViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForSingleButtonTableCell) as! SingleButtonTableViewCell
            if indexPath.row == 0 {
                cell.button.setTitle("更新字体", forState: .Normal)
                cell.button.addTarget(self, action: "updateFont", forControlEvents: .TouchUpInside)
            }
            else if indexPath.row == 2 {
                cell.button.setTitle("发送字体到邮箱", forState: .Normal)
                cell.button.addTarget(self, action: "emailFont", forControlEvents: .TouchUpInside)
            }
            else if indexPath.row == 4 {
                cell.button.setTitle("退出登录", forState: .Normal)
                cell.button.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func updateFont() {
        
    }
    
    func emailFont() {
        
    }
    
    func logout() {
        
        UserProfile.hasLoggedIn = false
        
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForLoginViewController)
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
