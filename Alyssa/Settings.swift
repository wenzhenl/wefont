//
//  Constants.swift
//  Alyssa
//
//  Created by Wenzheng Li on 10/20/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    
    // MARK - Identifiers for table cells
    static let IdentifierForBookTitleCell = "Book Title Table Cell"
    static let IdentifierForSingleButtonTableCell = "Single Button Table Cell"
    static let IdentifierForUserInfoTableCell = "User Info Table Cell"
    static let IdentifierForSingleLabelTableCell = "Single Label Table Cell"
    
    // MARK - Identifiers for collection view cells
    static let IdentifierForSingleCharCollectionCell = "Single Char Collection View Cell"
    
    // MARK - Identifiers for segues
    static let IdentifierForSegueToBookContent = "To Book Content"
    static let IdentifierForSegueFromLoginToTabView = "Successfully Login"
    static let IdentifierForSegueToCreateFont = "Present Create Font"
    static let IdentifierForSegueToAboutAlyssa = "Go To See About Alyssa"
    static let IdentifierForSegueToAcknowledgePage = "Go to see acknowledge page"
    static let IdentifierForSegueToNextStepResetPassword = "Next step to reset password"
    static let IdentifierForSegueToLogin = "Please login first"
    static let IdentifierForSegueFromCharCaptureToLogin = "From char capture to login"
    static let IdentifierForSegueFromMeToLogin = "From ME capture to login"
    
    // MARK - Identifiers for storyboards
    static let IdentifierForTabViewController = "Tab Bar Controller"
    static let IdentifierForLoginViewController = "Login View Controller"
    static let IdentifierForTutorialViewController = "Tutorial View Controller ID"
    static let IdentifierForPageViewController = "Universal Page View Controller"
    static let IdentifierForContentViewController = "Tutorial Content View Controller"
    static let IdentifierForHomePageContentViewController = "Home Page Content ID"
    static let IdentifierForBookPageContentViewController = "This is a book page content view"
    static let IdentifierForCustomizedAlertViewController = "Customized Alert View Controller"
    static let IdentifierForAlertInputViewController = "InputAlertForBookName"
    static let IdentifierForWelcomeViewController = "WelcomeInfoFromQianqian"
    
    // MARK - parameters for gestures
    static let GestureScaleForMovingHandwritting = CGFloat(2.0)
    
    // MARK - parameters for color
    static let avaiableHandwrittingColors =
    [   UIColor(red: 1.0, green: 153.0/255.0, blue: 51/255.0, alpha: 1.0),
        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
        UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        UIColor(red: 0.0078, green: 0.517647, blue: 0.5098039, alpha: 1.0),
        UIColor(red: 0, green: 0.4, blue: 0.6, alpha: 1.0),
        UIColor(red: 1.0, green: 0.4, blue: 0, alpha: 1.0)
    ]
    
    // MARK - color for header
    static let ColorOfStamp = UIColor(red: 192.0/255.0, green: 0.0/255.0, blue: 14.0/255.0, alpha: 1.0)
    static let ColorOfAlertView = UIColor(red: 234.0 / 255.0, green: 69.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)

    // MARK - Server and API names
    static let ServerIP = "http://ohalyssa.com/Alyssa/"
    static let APIUserSignup = "alyssa_user_signup.php"
    static let APIUserLogin = "alyssa_user_login.php"
    static let APIUserRequestValidationCode = "alyssa_request_validation_code.php"
    static let APIConfirmValidationCode = "alyssa_confirm_validation_code.php"
    static let APIUserResetPassword = "alyssa_user_reset_password.php"
    static let APIFetchingLatestFont = "alyssa_fetch_latest_font.php"
    static let APICreateNewFont = "alyssa_create_font.php"
    static let APICreateGlyph = "alyssa_create_glyph.php"
    static let APIEmailFontToUser = "alyssa_email_font.php"
    static let APIFetchBook = "alyssa_fetch_book.php"
    
    // MARK - Keys for UIDefaultUser
    // app related
    static let keyForLatestVersionInDefaultUser = "keyForLatestVersion"
    static let keyForLaunchedBeforeInDefaultUser = "keyForLaunchedBefore"
    
    // user app interaction
    static let keyForHasLoggedInInDefaultUser = "keyForHasLoggedIn"
    static let keyForHasSeenTutorialInDefaultUser = "keyForHasSeenTutorial"
    static let keyForHasSeenTipForCreateFont = "keyForHasSeenTipForCreateFont"
    static let keyForHasSeenTipForCharGridView = "keyForHasSeenTipForCharGridView"
    static let keyForHasSeenTipForRestartApp = "keyForHasSeenTipForRestartApp"
    static let keyForHasSeenTipForEditingMode = "keyForHasSeenTipForEditingMode"
    static let keyForHasSeenTipForUndoErasing = "keyForHasSeenTipForUndoErasing"
    
    // user account related
    static let keyForNicknameInDefaultUser = "keyForUserNickname"
    static let keyForUserEmailInDefaultUser = "keyForUserEmail"
    static let keyForUserPasswordInDefaultUser = "keyForUserPassword"
    
    // font related
    static let keyForActiveFontInDefaultUser = "keyForActiveFont"
    static let keyForFontsLastModifiedTimeInDefaultUser = "keyForFontLastModifiedTime"
    static let keyForFontsFinishedCharsInDefaultUser = "keyForFontFinishedChars"
    static let keyForHasSavedFontInDefaultUser = "keyForHasSavedFont"
    
    // home view related
    static let keyForCurrentLevelInDefaultUser = "keyForCurrentLevel"
    
    // book related
    static let keyForUserAddedBooksInDefault = "keyForUserAddedBooks"
    static let keyForCurrentChapterForBooksInDefault = "keyForCurrentChapterOfAllBooks"
    
    // MARK - UI related parameters
    static let widthOfCurrentCharTextFieldNeedingUpdateInStoryboardIfChanged = 40
    static let WidthOfCharGridView = CGFloat(130.0)
    static let AspectRatioOfCharGridView = CGFloat(1.0)
    static let VerticalOffsetOfCharGridView = CGFloat(200)
    
    static let WidthOfCustomizedAlertView = CGFloat(230.0)
    static let HeightOfCustomizedAlertView = CGFloat(50.0)
    static let VerticalOffsetOfCustomizedAlertView = CGFloat(100.0)
    
    static let VerticalOffsetOfCharUnderscore = CGFloat(7.0)
    
//    static let minimumWidthOfCharGrid = CGFloat(30)
    
    // MARK - System default books
    static let defaultSampleBooks = ["手写练习区", "小王子", "唐诗精选", "gb2312"]
    static let bookNameOfGB2312 = "gb2312"
    static let BookContentSeparationString = "THISISASEPARATIONSTRINGUSEDTOSEPARATECONTENTOFBOOKINTOCHAPTERS"
    
    // MARK - index for tab view controllers
    static let indexOfCharCaptureViewController = 1
    
    
    // MARK - eraser brush size
    static let minBrushSize = Float(10.0)
    static let midBrushSize = Float(20.0)
    static let maxBrushSize = Float(40.0)
    
    
    
    // MARK - error info when request data from server
    static let errMsgServerDown = "囧，服务器开小差了"
    
    // MARK - Common functions used by all viewcontroller
    
    // MARK - input validation
    static let patternForEmptyString = "^\\s*$"
    
    static func isEmpty(string: String?) -> Bool {
        if string == nil {
            return true
        }
        if string?.rangeOfString(patternForEmptyString, options: .RegularExpressionSearch) != nil {
            return true
        }
        return false
    }

    
    static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    // MARK - interaction with the server
    static func fetchDataFromServer(viewController: UIViewController, errMsgForNetwork: String, destinationURL: String, params: NSDictionary, retrivedJSONHandler: (NSDictionary?) -> Void) {
        
        if !NetworkAvailability.isConnectedToNetwork() {
            
            // Notify users there's error with network
            popupCustomizedAlert(viewController, message: errMsgForNetwork)
        } else {
           
            let url = Settings.ServerIP + destinationURL
            print(url)
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
            }  catch  {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    var err: NSError?
                    var json:NSDictionary?
                    do{
                        json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    }catch{
                        print(error)
                        err = error as NSError
                    }
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(err != nil) {
                        print("Response: \(response)")
                        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Body: \(strData!)")
                        print(err!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: '\(jsonStr)'")
                        viewController.dismissViewControllerAnimated(true) {
                            popupCustomizedAlert(viewController, message: "囧：服务器开小差了")
                        }
                    } else {
                        retrivedJSONHandler(json)
                    }
                }
            })
            
            task.resume()
        }
    }
    
    static func popupCustomizedAlert(viewController: UIViewController, message: String) {
        let customizedAlert = viewController.storyboard?.instantiateViewControllerWithIdentifier(IdentifierForCustomizedAlertViewController) as! CustomizedAlertViewController
        customizedAlert.message = message
        customizedAlert.modalTransitionStyle = .FlipHorizontal
        customizedAlert.modalPresentationStyle = .OverFullScreen
        if viewController.presentedViewController != nil {
            viewController.dismissViewControllerAnimated(true) {
               
                viewController.presentViewController(customizedAlert, animated: true, completion: nil)
                
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    viewController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        } else {
            
            viewController.presentViewController(customizedAlert, animated: true, completion: nil)
            
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
    }
    
    static func popupCustomizedAlertNotDissmissed (viewController: UIViewController, message: String) {
        let customizedAlert = viewController.storyboard?.instantiateViewControllerWithIdentifier(IdentifierForCustomizedAlertViewController) as! CustomizedAlertViewController
        customizedAlert.message = message
        customizedAlert.modalTransitionStyle = .FlipHorizontal
        customizedAlert.modalPresentationStyle = .OverFullScreen
        
        if viewController.presentedViewController != nil {
            viewController.dismissViewControllerAnimated(true) {
                viewController.presentViewController(customizedAlert, animated: true, completion: nil)
            }
        } else {
            viewController.presentViewController(customizedAlert, animated: true, completion: nil)
        }
    }
    
    static func fetchLatestFont(viewController : UIViewController, retrivedJSONHandler: (NSDictionary?) -> Void) {
        if UserProfile.userEmailAddress != nil && UserProfile.userPassword != nil {
            if UserProfile.activeFontName != nil {
                let params = NSMutableDictionary()
                
                params["email"] = UserProfile.userEmailAddress!
                params["password"] = UserProfile.userPassword!
                params["fontname"] = UserProfile.activeFontName!
                if let lastModifiedTime = UserProfile.getFontLastModifiedTimeOf(UserProfile.activeFontName!) {
                    params["last_modified_time"] = lastModifiedTime
                }
                
                print("fetching data from server")
                let errInfoForNetwork = "无网络连接"
                
                fetchDataFromServer(viewController, errMsgForNetwork: errInfoForNetwork, destinationURL: Settings.APIFetchingLatestFont, params: params, retrivedJSONHandler: retrivedJSONHandler)
            } else {
                Settings.popupCustomizedAlert(viewController, message: "你还没有创建任何字体")
            }
        }
    }
    
    static func updateFont(fontFileURL: NSURL) {
        let fontData: NSData? = NSData(contentsOfURL: fontFileURL)
        if fontData == nil {
            print("Failed to load saved font:", fontFileURL.absoluteString)
        }
        else {
            var error: Unmanaged<CFError>?
            let provider = CGDataProviderCreateWithCFData(fontData)
            let font = CGFontCreateWithDataProvider(provider)
            if font != nil {
                if !CTFontManagerRegisterGraphicsFont(font!, &error) {
                    print("Failed to register font, error", error)
                } else {
                    UserProfile.hasSavedFont = true
                    print("Successfully registered font", fontFileURL.absoluteString)
                }
            } else {
                print("Your font data is nil")
            }
        }
    }
    
    static let NumOfCharactersPerLevel = 100
    static let NumOfCharactersPerPage = 20
    
    static func getAllCharsSeparatedBy100PerLevelAnd20PerPage() -> [[String]]{
        var GB2312 : [[String]] = []
        
        let url = NSBundle.mainBundle().URLForResource(self.bookNameOfGB2312, withExtension: "txt")
        do {
            let contentFromGB2312 = try String(contentsOfURL: url!)
            let trimmedContent = contentFromGB2312.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            print(trimmedContent.characters.count)
            
            // MARK - split into levels first
            let splitedForLevels = splitStringToEqualLength(trimmedContent, length: NumOfCharactersPerLevel)
            for s in splitedForLevels {
                let splitedFurtherForPage = splitStringToEqualLength(s, length: NumOfCharactersPerPage)
                GB2312.append(splitedFurtherForPage)
            }
        } catch {
            print(error)
        }
        
        return GB2312
    }
    
    static func splitStringToEqualLength(string: String, length: Int) -> [String] {
        
        var splitedStrings : [String] = []
        
        var index = 0
        let numOfChars = string.characters.count
        while index + length <= numOfChars {
            let stringFromIndexToEnd = string.substringFromIndex(string.startIndex.advancedBy(index))
            let stringFromIndexWithDesiredLength = stringFromIndexToEnd.substringToIndex(stringFromIndexToEnd.startIndex.advancedBy(length))
            splitedStrings.append(stringFromIndexWithDesiredLength)
            index += length
        }
        if index + length > numOfChars && index < numOfChars {
            splitedStrings.append(string.substringFromIndex(string.startIndex.advancedBy(index)))
        }
        return splitedStrings
    }
    
    
    // MARK - ERROR CODE MAPPING
    
    static let ErrMsgForErrCode : [String: String] = [
        // General Error
        "0001" : "囧，服务器开小差了", // parsing DB ini file failed
        "0002" : "囧，服务器开小差了", // mysqli DB connection error
        "0003" : "囧，服务器开小差了", // unable to set charset = utf8 on DB connection
        "0004" : "囧，服务器开小差了", // failed to execute DB query
        "0005" : "用户不存在", // user email not exist
        "0006" : "密码错误", // user password incorrect
        "0007" : "囧，服务器开小差了", //  DB data inconsistent
        
        // API 1
        // alyssa_user_signup.php
        "0101" : "囧，服务器开小差了", // JSON object error
        "0102" : "用户邮箱已经存在", // user email exists already
        "0103" : "囧，服务器开小差了", //mkdir error
        
        // API 2
        // alyssa_user_login.php
        "0201" : "囧，服务器开小差了", // JSON object error
        
        // API 3
        // alyssa_request_validation_code.php
        "0301" : "囧，服务器开小差了", // JSON object error
        "0302" : "用户不存在", // provided email not found in DB
        "0303" : "囧，无法发送验证码", // failed to send vc to user email
        
        // API 4
        // alyssa_request_validation_code.php
        "0401" : "囧，服务器开小差了", // JSON object error
        "0402" : "用户不存在", //provided email not found in DB
        "0403" : "验证码不正确", // validation code incorrect
        "0404" : "验证码已过期", // validation code expired
        
        // API 5
        // alyssa_user_reset_password.php
        "0501" : "囧，服务器开小差了", // JSON object error
        "0502" : "用户不存在", // provided email not found in DB
        "0503" : "验证码不正确", // validation code incorrect
        "0504" : "验证码已过期", // validation code expired
        
        // API 6
        // alyssa_create_font.php
        "0601" : "囧，服务器开小差了", // JSON object error
        "0602" : "字体已经存在", // same fontname already exists
        "0603" : "无法创建字体", // failed to create the font file
        "0604" : "无法创建字体", //failed to create the font directory
        
        // API 7
        // alyssa_create_glyph.php
        "0701" : "囧，服务器开小差了", // JSON object error
        "0702" : "字体不存在", // fontname not found or is inactive
        "0703" : "传送图片格式不对", // glyph image is not a JPEG image
        "0704" : "囧，服务器开小差了", // failed to write glyph image to disk
        "0705" : "无法添加字图", // fails to add glyph into font
        
        // API 8
        // alyssa_fetch_latest_font.php
        "0801" : "囧，服务器开小差了", // JSON object error
        "0802" : "字体不存在", // fontname not found
        "0803" : "囧，无法下载字体", // failed to load font from disk
        
        // API 9
        // alyssa_email_font.php
        "0901" : "囧，服务器开小差了", // JSON object error
        "0902" : "字体不存在", // fontname not found
        "0903" : "无法发送字体", // failed to sent font to user email
        
        // API 10
        // alyssa_switch_active_font.php
        "1001" : "囧，服务器开小差了", // JSON object error
        "1002" : "字体不存在", // fontname not found
        
        // API 11
        // alyssa_update_user_email.php
        
        // API 12
        // alyssa_fetch_book.php
        "1201" : "囧，服务器开小差了", // JSON object error
        "1202" : "找不到你要的图书" // fails to load book from disk
    ]
    
    static func decodeErrorCode(errorCode: String?) -> String {
        if let errorCode = errorCode {
            if let errorInfo = ErrMsgForErrCode[errorCode] {
                return errorInfo
            }
        }
        return "囧，未知错误"
    }
}
