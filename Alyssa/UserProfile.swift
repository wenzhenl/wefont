//
//  UserProfile.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/27/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import Foundation

class UserProfile {
    
    // MARK - user account info
    static var userEmailAddress: String?
    static var userPassword: String?
    static var userNickname: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForNicknameInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForNicknameInDefaultUser)
        }
    }
    
    // MARK - user font info
    static var activeFontName: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForActiveFontInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForActiveFontInDefaultUser)
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
    
    static var fontsLastModifiedTime: [String: Double]? {
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForFontsLastModifiedTimeInDefaultUser) as! [String: Double]?
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForFontsLastModifiedTimeInDefaultUser)
        }
    }
    
    static var fontsNumOfFinishedChars: [String: Int]? {
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForFontsFinishedCharsInDefaultUser) as! [String: Int]?
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForFontsFinishedCharsInDefaultUser)
        }
    }
    
    // MARK - Home view related
    static var currentLevel: Int! {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Settings.keyForCurrentLevelInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForCurrentLevelInDefaultUser)
        }
    }
    
    // MARK - char capture view related
    static var activeChar: String?
    
    // MARK - User added books
    static var userAddedBooks: [String]? {
        get {
            return NSUserDefaults.standardUserDefaults().stringArrayForKey(Settings.keyForUserAddedBooksInDefault)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForUserAddedBooksInDefault)
        }
    }
    
    static func fetchPathOfBook(bookName: String) -> NSURL? {
        if ((userAddedBooks?.contains(bookName)) != nil) {
            if let docsDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                let bookFileURL = docsDir.URLByAppendingPathComponent(bookName + ".txt")
                return bookFileURL
            }
        }
        return nil
    }
}