//
//  BookContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/26/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class BookContentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var bookTitle: String!
    
    var chapters: [String]!
    
    var currentChapter: Int! {
        get {
            if let currentChapterOfBooks = UserProfile.currentChapterOfAllBooks {
                if let currentChapterRecord = currentChapterOfBooks[bookTitle] {
                    return currentChapterRecord
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
        set {
            if UserProfile.currentChapterOfAllBooks != nil {
                UserProfile.currentChapterOfAllBooks![bookTitle] = newValue
            } else {
                UserProfile.currentChapterOfAllBooks = [bookTitle : newValue]
            }
        }
    }
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url : NSURL?
        if Settings.defaultSampleBooks.contains(bookTitle) {
            url = NSBundle.mainBundle().URLForResource(bookTitle, withExtension: "txt")
        } else {
            url = UserProfile.fetchPathOfBook(bookTitle)
        }
        do {
            let entireBookContent = try String(contentsOfURL: url!)
            chapters = entireBookContent.componentsSeparatedByString(Settings.BookContentSeparationString)
            print("Successfully loaded book ", bookTitle, " with ", chapters.count, " chapters")
        } catch {
            print(error)
        }

        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Settings.IdentifierForPageViewController) as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let startVC = self.viewControllerAtIndex(currentChapter) as BookPageContentViewController
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
        if bookTitle == Settings.defaultSampleBooks[0] {
            vc.editable = true
        } else {
            vc.editable = false
        }
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
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentPage = pageViewController.viewControllers!.first as! BookPageContentViewController
            currentChapter = currentPage.pageIndex
            print("current page: ", currentChapter)
        }
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return self.chapters.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}