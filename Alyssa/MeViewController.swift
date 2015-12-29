//
//  MeViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/24/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = Settings.ColorOfStamp
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Settings.IdentifierForSingleButtonTableCell) as! SingleButtonTableViewCell
        cell.button.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
        return cell
    }
    
    func logout() {
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier(Settings.IdentifierForLoginViewController)
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
