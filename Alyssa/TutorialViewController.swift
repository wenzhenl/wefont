//
//  TutorialViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/29/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {

    @IBOutlet weak var enterAlyssaButton: UIButton!
    
    var pageViewController: UIPageViewController!
    
    var pageTitles: [String]!
    
    var pageImages: [String]!
    
    @IBOutlet weak var buttonContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.buttonContainerView.backgroundColor = Settings.ColorOfStamp
        self.buttonContainerView.layer.cornerRadius = 4
        self.buttonContainerView.layer.borderColor = Settings.ColorOfStamp.CGColor
        self.buttonContainerView.layer.borderWidth = 1
        self.enterAlyssaButton.setTitleColor(Settings.ColorOfStamp, forState: .Normal)
//        self.view.backgroundColor = UIColor.greenColor()
        
        self.pageTitles = ["人类,第一次,制作个人手写字体如此简单", "一心一意呵护你的一笔一划", "最是那一低头的温柔", "永远的Alyssa"]
        self.pageImages = ["page1", "page2", "page3", "page4"]
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForPageViewController) as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as TutorialContentViewController
        let viewControllers = [startVC]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 100)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterAlyssa() {
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForLoginViewController)
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func viewControllerAtIndex(index: Int) -> TutorialContentViewController {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count {
            return TutorialContentViewController()
        }
        
        let vc: TutorialContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForContentViewController) as! TutorialContentViewController
        vc.titleText = pageTitles[index]
        vc.imageName = pageImages[index]
        vc.pageIndex = index
        return vc
    }
    
    //MARK: - Page View Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! TutorialContentViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! TutorialContentViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.pageTitles.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
