//
//  ViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    
    var entireGB2312Chars: [[String]]!
    
    var pageStringsConsistingOfChars: [String]!
    
    var currentLevel: Int = 0 {
        didSet {
            titleBarButtonItem.title = "第\(currentLevel+1)关 最常用\((currentLevel+1)*Settings.NumOfCharactersPerLevel)字"
            UserProfile.currentLevel = currentLevel
        }
    }
    
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
        
        self.pageViewController.view.frame = CGRectMake(0, 110, self.view.frame.width, self.view.frame.maxY - 150)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    @IBAction func addNewFont(sender: UIBarButtonItem) {
        // TODO - simulate adding font here
        let newFontName = "FZJingLeiS-R-GB"
      
        UserProfile.activeFontName = newFontName
        
        Settings.popupCustomizedAlert(self, message: "请重启APP查看效果" + newFontName)
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
        if currentLevel == entireGB2312Chars.count {
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

