//
//  MeViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForUserInfoTableCell) as! UserInfoTableViewCell
            cell.nickname = UserProfile.userNickname
            cell.email = UserProfile.userEmailAddress
            cell.selectionStyle = .None
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForSingleButtonTableCell) as! SingleButtonTableViewCell
            if indexPath.row == 0 {
                cell.button.setTitle("更新字体", forState: .Normal)
                cell.button.setTitleColor(Settings.ColorOfStamp, forState: .Normal)
                cell.button.addTarget(self, action: "updateFont", forControlEvents: .TouchUpInside)
            }
            else if indexPath.row == 1 {
                cell.button.setTitle("发送字体到邮箱", forState: .Normal)
                cell.button.setTitleColor(Settings.ColorOfStamp, forState: .Normal)
                cell.button.addTarget(self, action: "emailFont", forControlEvents: .TouchUpInside)
            }
            
            return cell
        }
        
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForSingleLabelTableCell) as! SingleLabelTableViewCell
            if indexPath.row == 0 {
                cell.singleLabel.text = "关于Alyssa"
                cell.selectionStyle = .None
            }
            else if indexPath.row == 1 {
                cell.singleLabel.text = "致谢"
                cell.selectionStyle = .None
            }
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForSingleButtonTableCell) as! SingleButtonTableViewCell
            cell.button.setTitle("退出登录", forState: .Normal)
            cell.button.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            performSegueWithIdentifier(Settings.IdentifierForSegueToAboutAlyssa, sender: self)
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            performSegueWithIdentifier(Settings.IdentifierForSegueToAcknowledgePage, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 3 {
            return 70
        }
        return 30
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        else if section == 3 {
            return 20
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 50
        }
    }
    
    func updateFont() {
        Settings.popupCustomizedAlert(self, message: "已经更新到最新版本")
    }
    
    func emailFont() {
        Settings.popupCustomizedAlert(self, message: "已经发送到邮箱")
    }
    
    func logout() {
        
        UserProfile.hasLoggedIn = false
        
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForLoginViewController)
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
