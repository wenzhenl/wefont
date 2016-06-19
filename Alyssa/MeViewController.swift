//
//  MeViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit
import EasyTipView

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EasyTipViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    @IBOutlet weak var updateFontBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        if !UserProfile.hasSeenRestartAPPTip {
            EasyTipView.showAnimated(true, forItem: self.updateFontBarButtonItem, withinSuperview: self.navigationController?.view,
                text: "更新字体后你需要重启美字精灵才可以看到最新效果。重启的方式是双击Home键将美字精灵向上滑出\r\n\r\n点击关闭提示。", delegate: self)
            UserProfile.hasSeenRestartAPPTip = true
        }
    }
    
    // MARK - easy tip view delegate functions
    func easyTipViewDidDismiss(tipView: EasyTipView) {
        print("\(tipView) did dismiss!")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
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
            cell.nickname = UserProfile.userNickname ?? "未登录"
            cell.email = UserProfile.userEmailAddress ?? "example@example.com"
            cell.selectionStyle = .None
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForSingleButtonTableCell) as! SingleButtonTableViewCell
            if indexPath.row == 0 {
                cell.button.setTitle("下载最新字体", forState: .Normal)
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
                cell.singleLabel.text = "关于美字精灵"
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
        } else if indexPath.section == 0 && indexPath.row == 0 {
            if !UserProfile.hasLoggedIn {
                performSegueWithIdentifier(Settings.IdentifierForSegueFromMeToLogin, sender: self)
            }
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
    
    @IBAction func updateFont() {
        
        if !UserProfile.hasLoggedIn {
            performSegueWithIdentifier(Settings.IdentifierForSegueFromMeToLogin, sender: self)
        }
        else if checkInputs() {
            
            let alert = UIAlertController(title: "更新字体", message:"本次操作会消耗不少流量，确定继续？", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "继续",
                style: .Destructive)
                { (action: UIAlertAction) -> Void in
                    Settings.fetchLatestFont(self, retrivedJSONHandler: self.handleRetrivedFontData)
                    Settings.popupCustomizedAlert(self, message: "正在请求你的最新字体")

                }
            )
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func handleRetrivedFontData(json: NSDictionary?) {
        if let parseJSON = json {
            // Okay, the parsedJSON is here, let's check if the font is still fresh
            if let success = parseJSON["success"] as? Bool {
                print("Success: \(success)")
                
                if let message = parseJSON["message"] as? String {
                    print("load font ", message)
                    if success {
                        
                        if let fontString = parseJSON["font"] as? String {
                            if let fontData = NSData(base64EncodedString: fontString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                                print("successfully parsed font data")
                                
                                if let lastModifiedTime = parseJSON["last_modified_time"] as? String {
                                    self.saveFontDataToFileSystem(fontData, lastModifiedTime: lastModifiedTime)
                                    Settings.popupCustomizedAlert(self, message: "请重启APP查看最新字体")
                                } else {
                                    print("cannot parse last modified time")
                                }
                            } else {
                                print("Failed convert base64 string to NSData")
                            }
                        } else {
                            print("cannot convert data to String")
                        }
                    } else {
                        print("seems the font is latest")
                        Settings.popupCustomizedAlert(self, message: "当前字体已经是最新的")
                    }
                } else {
                    print("cannot parse message")
                    Settings.popupCustomizedAlert(self, message: Settings.errMsgServerDown)
                }
            }
        } else {
            print("Cannot fetch data")
        }
    }
    
    func saveFontDataToFileSystem(fontData: NSData, lastModifiedTime: String) {
        if let fontFileURL = UserProfile.fontFileURL {
            
            if !fontData.writeToURL(fontFileURL, atomically: true) {
                print("Failed to save font", fontFileURL.absoluteString)
            } else {
                print("Successfully saved font ", fontFileURL.absoluteString)
                UserProfile.updateFontLastModifiedTimeOf(UserProfile.activeFontName!, newTime: lastModifiedTime)
                Settings.updateFont(fontFileURL)
                print("successfully updated font \(UserProfile.activeFontName)")
            }
        }
    }

    func checkInputs() -> Bool  {
        
        if !UserProfile.hasLoggedIn {
            Settings.popupCustomizedAlert(self, message: "你还没有登录")
            return false
        }
        
        if Settings.isEmpty(UserProfile.userEmailAddress) {
            Settings.popupCustomizedAlert(self, message: "邮箱不能为空")
        } else if !Settings.isValidEmail(UserProfile.userEmailAddress!) {
            Settings.popupCustomizedAlert(self, message: "邮箱地址是无效的")
        } else if Settings.isEmpty(UserProfile.userPassword) {
            Settings.popupCustomizedAlert(self, message: "密码不能为空")
        } else if Settings.isEmpty(UserProfile.activeFontName) {
            Settings.popupCustomizedAlert(self, message: "你还没有创建字体")
        } else {
            return true
        }
        return false
    }

    func emailFont() {
        
        if !UserProfile.hasLoggedIn {
            performSegueWithIdentifier(Settings.IdentifierForSegueFromMeToLogin, sender: self)
        }
        else if checkInputs() {
            let alert = UIAlertController(title: "发送字体", message:"你的邮箱地址是 " + UserProfile.userEmailAddress!, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "确定",
                style: .Destructive)
                { (action: UIAlertAction) -> Void in
                    let params = NSMutableDictionary()
                    
                    params["email"] = UserProfile.userEmailAddress!
                    params["password"] = UserProfile.userPassword!
                    params["fontname"] = UserProfile.activeFontName!
                    
                    let message = "无网络连接"
                    Settings.fetchDataFromServer(self, errMsgForNetwork: message, destinationURL: Settings.APIEmailFontToUser, params: params, retrivedJSONHandler: self.handleEmailFontResponse)
                    Settings.popupCustomizedAlert(self, message: "已经成功发送请求")
                }
            )
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func handleEmailFontResponse (json: NSDictionary?) {
        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("Email font success ",  success)
                if let message = parseJSON["message"] as? String {
                    print("Email font message: ", message)
                    
                    if success {
                        print("Email font success")
                        Settings.popupCustomizedAlert(self, message: "字体已发送到邮箱，请查收")
                    } else {
                        print("Email font not success")
                        Settings.popupCustomizedAlert(self, message: Settings.decodeErrorCode(message))
                    }
                }
            }
        }
    }

    func logout() {
        
        if !UserProfile.hasLoggedIn {
            Settings.popupCustomizedAlert(self, message: "你还没有登录")
        } else {
            let alert = UIAlertController(title: "美字精灵", message:"确定退出登录么?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "确定",
                style: .Default)
                { (action: UIAlertAction) -> Void in
                    UserProfile.hasLoggedIn = false
                    UserProfile.hasSavedFont = false
                    UserProfile.userEmailAddress = nil
                    UserProfile.userNickname = nil
                    UserProfile.userPassword = nil
                    UserProfile.activeFontName = nil
                    UserProfile.fontsLastModifiedTime = nil
                    
                    self.tableView.reloadData()
                }
            )
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
