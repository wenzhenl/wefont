//
//  BookContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/26/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class BookContentViewController: UIViewController, UIPageViewControllerDataSource {
    
    var bookTitle: String!
    
    var chapters: [String]!
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource(bookTitle, withExtension: "txt")
        do {
            let entireBookContent = try String(contentsOfURL: url!)
            chapters = entireBookContent.componentsSeparatedByString(Settings.BookContentSeparationString)
            print("Successfully loaded book ", bookTitle, " with ", chapters.count, " chapters")
        } catch {
            print(error)
        }

        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForPageViewController) as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as BookPageContentViewController
        let viewControllers = [startVC]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.maxY - 110)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index: Int) -> BookPageContentViewController {
        if self.chapters.count == 0 || index >= self.chapters.count {
            return BookPageContentViewController()
        }
        
        let vc: BookPageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForBookPageContentViewController) as! BookPageContentViewController
        vc.chapterContent = chapters[index]
        vc.pageIndex = index
        return vc
    }
    
    //MARK: - Page View Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! BookPageContentViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! BookPageContentViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == self.chapters.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return self.chapters.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}