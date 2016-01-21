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
    static var userEmailAddress: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForUserEmailInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForUserEmailInDefaultUser)
        }
    }
    static var userPassword: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForUserPasswordInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForUserPasswordInDefaultUser)
        }
    }
    
    static var userNickname: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Settings.keyForNicknameInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForNicknameInDefaultUser)
        }
    }
    
    // MARK - USER APP interaction
    static var hasLoggedIn: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyForHasLoggedInInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForHasLoggedInInDefaultUser)
        }
    }
    
    static var hasSeenTutorial: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyForHasSeenTutorialInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForHasSeenTutorialInDefaultUser)
        }
    }
    
    static var hasSeenFontCreationTip: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyForHasSeenTipForCreateFont)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForHasSeenTipForCreateFont)
        }
    }

    static var hasSeenCharGridViewTip: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyForHasSeenTipForCharGridView)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForHasSeenTipForCharGridView)
        }
    }
    
    static var hasSeenRestartAPPTip: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyForHasSeenTipForRestartApp)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForHasSeenTipForRestartApp)
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
    
    static var hasSavedFont: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Settings.keyForHasSavedFontInDefaultUser)
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: Settings.keyForHasSavedFontInDefaultUser)
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
    
    static var fontsLastModifiedTime: [String: String]? {
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForFontsLastModifiedTimeInDefaultUser) as! [String: String]?
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForFontsLastModifiedTimeInDefaultUser)
        }
    }
    
    static func getFontLastModifiedTimeOf (fontName : String) -> String? {
        if fontsLastModifiedTime != nil {
            return fontsLastModifiedTime![fontName]
        } else {
            return nil
        }
    }
    
    static func updateFontLastModifiedTimeOf (fontName: String, newTime: String) {
        if fontsLastModifiedTime != nil {
            fontsLastModifiedTime![fontName] = newTime
        } else {
            fontsLastModifiedTime = [fontName : newTime]
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
    
    static var currentChapterOfAllBooks: [String: Int]? {
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Settings.keyForCurrentChapterForBooksInDefault) as! [String: Int]?
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Settings.keyForCurrentChapterForBooksInDefault)
        }
    }
    
    
    // MARK - used to transfer temp variable
    static var newFontReadyTosend : Bool = false
    static var newFontName : String?
    static var copyright: String?
    static var version: String?
    
    static var requestedBookName : String?
}