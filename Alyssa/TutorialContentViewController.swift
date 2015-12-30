//
//  ContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/29/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var titleText: String!
    var imageName: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imageView.image = UIImage(named: self.imageName)
        
        self.titleLabel.text = self.titleText
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
