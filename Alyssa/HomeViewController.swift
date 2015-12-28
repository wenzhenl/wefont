//
//  ViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
        
        // TODO - simulate adding font here
        
        if let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] {
            print("version: ", version)
            if let latestVersion = NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForLatestVersionInDefaultUser) {
                print("Latest version: ", latestVersion)
                if version as! String != latestVersion {
                    print("Updated")
                    NSUserDefaults.standardUserDefaults().setValue(version, forKey: Settings.keyForLatestVersionInDefaultUser)
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: Settings.keyForFontPathInDefaultUser)
                    
                } else {
                    print("NOT updated")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setValue(version, forKey: Settings.keyForLatestVersionInDefaultUser)
            }
        }
        
        let newFontName = "FZJingLeiS-R-GB"
//        let newFontName = "Leeyukuang"
        if let docsDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            let newFontFileURL = docsDir.URLByAppendingPathComponent(newFontName + ".ttf")
            if let pathsOfFonts = NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForFontPathInDefaultUser) {
                let newPathsOfFonts = NSMutableDictionary(dictionary: pathsOfFonts)
                if newPathsOfFonts[newFontName] == nil {
                    newPathsOfFonts[newFontName] = newFontFileURL.absoluteString
                    NSUserDefaults.standardUserDefaults().setObject(newPathsOfFonts, forKey: Settings.keyForFontPathInDefaultUser)
                } else {
                    print("Failed adding existing font path")
                }
            } else {
                print("First time adding a font")
                let newPathsOfFonts = [newFontName: newFontFileURL.absoluteString]
                print("newPath:", newFontFileURL.absoluteString)
                NSUserDefaults.standardUserDefaults().setObject(newPathsOfFonts, forKey: Settings.keyForFontPathInDefaultUser)
            }
        }
        
        UserProfile.currentFontName = newFontName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

