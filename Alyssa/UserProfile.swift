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
    
    static var activeFontName: String?
    
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
