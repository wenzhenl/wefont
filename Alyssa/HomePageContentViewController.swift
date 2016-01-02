//
//  HomePageContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/29/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class HomePageContentViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var singleCharsCollectionView: UICollectionView!
    
    var titleText: String!
    var stringConsistingOfChars: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringConsistingOfChars.characters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Settings.IdentifierForSingleCharCollectionCell, forIndexPath: indexPath) as! SingleCharCollectionViewCell
        
        // randomize view color
        let blueColor = CGFloat(Int(arc4random() % 255)) / 255.0
        let greenColor = CGFloat(Int(arc4random() % 255)) / 255.0
        let redColor = CGFloat(Int(arc4random() % 255)) / 255.0
        
        cell.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 0.7)
        
        cell.singleCharLabel.text = String(self.stringConsistingOfChars[self.stringConsistingOfChars.startIndex.advancedBy(indexPath.row)])
        if UserProfile.fontFileURL != nil {
            cell.singleCharLabel.font = UIFont(name: UserProfile.activeFontName!, size: 30)
        } else {
            print("Failed to use user font")
        }
        cell.layer.cornerRadius = 4
        cell.alpha = 0.8
//        cell.backgroundColor = Settings.ColorOfStamp
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        UserProfile.activeChar = String(self.stringConsistingOfChars[self.stringConsistingOfChars.startIndex.advancedBy(indexPath.row)])
        self.tabBarController?.selectedIndex = Settings.indexOfCharCaptureViewController
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
}