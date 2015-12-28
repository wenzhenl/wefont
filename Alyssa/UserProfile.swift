//
//  UserProfile.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/27/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import Foundation

class UserProfile {
    static var userEmailAddress: String?
    
    static var userPassword: String?
    
    static var activeFontName: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForActiveFontInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForActiveFontInDefaultUser)
        }
    }
    
    static var fontsLastModifiedTime: [String: Double]? {
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForFontsLastModifiedTimeInDefaultUser) as! [String: Double]?
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForFontsLastModifiedTimeInDefaultUser)
        }
    }
    
    static var booksPaths: [String: String]? {
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForBooksInDefaultUser) as! [String: String]?
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForBooksInDefaultUser)
        }
    }
    
    static var fontFileURL: NSURL? {
        if self.activeFontName != nil {
            if let docsDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                let newFontFileURL = docsDir.URLByAppendingPathComponent(activeFontName! + ".ttf")
                return newFontFileURL
            }
        }
        return nil
    }
}
