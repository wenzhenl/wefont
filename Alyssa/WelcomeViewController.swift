//
//  WelcomeViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/10/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func enterAlyssa() {
        
        UserProfile.hasSeenTutorial = true
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForTabViewController)
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
