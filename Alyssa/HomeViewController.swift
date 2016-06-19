//
//  ViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit
import EasyTipView

class HomeViewController: UIViewController, UIPageViewControllerDataSource, EasyTipViewDelegate {

    var pageViewController: UIPageViewController!
    
    var entireGB2312Chars: [[String]]!
    
    var pageStringsConsistingOfChars: [String]!
    
    var currentLevel: Int = 0 {
        didSet {
            titleBarButtonItem.title = "第\(currentLevel+1)关 最常用\((currentLevel+1)*Settings.NumOfCharactersPerLevel)字"
            UserProfile.currentLevel = currentLevel
        }
    }
    
    @IBOutlet weak var createFontButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        
        self.titleBarButtonItem.style = .Plain
        
        self.currentLevel = UserProfile.currentLevel
        self.entireGB2312Chars = Settings.getAllCharsSeparatedBy100PerLevelAnd20PerPage()
        self.pageStringsConsistingOfChars = entireGB2312Chars[currentLevel]
       
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForPageViewController) as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as HomePageContentViewController
        let viewControllers = [startVC]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 130, self.view.frame.width, self.view.frame.maxY - 180)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        if let fontname = UserProfile.activeFontName {
            self.navigationItem.title = fontname
        }
        
        if !UserProfile.hasSeenFontCreationTip {
            EasyTipView.showAnimated(true, forItem: self.createFontButtonItem, withinSuperview: self.navigationController?.view,
                text: "请首先创建字体，然后点击字名或者直接进入取字功能添加字到字体 \r\n\r\n点击关闭提示。", delegate: self)
            
            UserProfile.hasSeenFontCreationTip = true
        }
    }

    // MARK - easy tip view delegate functions
    func easyTipViewDidDismiss(tipView: EasyTipView) {
        print("\(tipView) did dismiss!")
    }

    @IBAction func addNewFont(sender: UIBarButtonItem) {
        if UserProfile.hasLoggedIn {
            let center = NSNotificationCenter.defaultCenter()
            
            center.addObserver(self, selector: "sendNewFontInfoToServer:", name: Settings.NameOfNotificationReadyCreateNewFont, object: nil )
            
            performSegueWithIdentifier(Settings.IdentifierForSegueToCreateFont, sender: self)
        } else {
            performSegueWithIdentifier(Settings.IdentifierForSegueToLogin, sender: self)
        }
    }
    
    func sendNewFontInfoToServer(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Settings.NameOfNotificationReadyCreateNewFont, object: nil)
        
        if UserProfile.newFontReadyTosend {
            let params = NSMutableDictionary()

            params["email"] = UserProfile.userEmailAddress!
            params["password"] = UserProfile.userPassword!
            params["fontname"] = UserProfile.newFontName!
            params["copyright"] = UserProfile.copyright!
            params["version"] = UserProfile.version!

            let errInfoForNetwork = "无网络连接"
            Settings.fetchDataFromServer(self, errMsgForNetwork: errInfoForNetwork, destinationURL: Settings.APICreateNewFont, params: params, retrivedJSONHandler: handleResponseFromServer)
        }
    }
    
    func handleResponseFromServer(json: NSDictionary?) {

        if let parseJSON = json {
            if let success = parseJSON["success"] as? Bool {
                print("success: ", success)
                if let message = parseJSON["message"] as? String {
                    print(message)
                    if success == true {
                        
                        UserProfile.activeFontName = UserProfile.newFontName
                        UserProfile.newFontReadyTosend = false
                        Settings.popupCustomizedAlert(self, message: "成功添加新字体")
                        if let fontname = UserProfile.activeFontName {
                            self.navigationItem.title = fontname
                        }
                        
                        UserProfile.hasSavedFont = false
                        
                    } else {
                        Settings.popupCustomizedAlert(self, message: Settings.decodeErrorCode(message))
                    }
                }
            }

        } else {
            print("Cannot fetch Data")
            Settings.popupCustomizedAlert(self, message: "不好意思，服务器出错了")
        }
    }
    
    
    @IBAction func goToPreviousLevel(sender: UIBarButtonItem) {
        if currentLevel == 0 {
            Settings.popupCustomizedAlert(self, message: "已经在第一关")
        } else {
            currentLevel--
            self.pageStringsConsistingOfChars = entireGB2312Chars[currentLevel]
            let startVC = self.viewControllerAtIndex(0) as HomePageContentViewController
            let viewControllers = [startVC]
            self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func goToNextLevel(sender: UIBarButtonItem) {
        if currentLevel == entireGB2312Chars.count - 1 {
            Settings.popupCustomizedAlert(self, message: "已经在最后一关")
        } else {
            currentLevel++
            self.pageStringsConsistingOfChars = entireGB2312Chars[currentLevel]
            let startVC = self.viewControllerAtIndex(0) as HomePageContentViewController
            let viewControllers = [startVC]
            self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> HomePageContentViewController {
        if self.pageStringsConsistingOfChars.count == 0 || index >= self.pageStringsConsistingOfChars.count {
            return HomePageContentViewController()
        }
        
        let vc: HomePageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForHomePageContentViewController) as! HomePageContentViewController
        vc.stringConsistingOfChars = pageStringsConsistingOfChars[index]
        vc.pageIndex = index
        return vc
    }
    
    //MARK: - Page View Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! HomePageContentViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! HomePageContentViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.pageStringsConsistingOfChars.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageStringsConsistingOfChars.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

