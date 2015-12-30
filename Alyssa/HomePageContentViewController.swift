//
//  HomePageContentViewController.swift
//  Alyssa
//
//  Created by Wenzheng Li on 12/29/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class HomePageContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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
        
        cell.singleCharLabel.text = String(self.stringConsistingOfChars[self.stringConsistingOfChars.startIndex.advancedBy(indexPath.row)])
        if UserProfile.fontFileURL != nil {
            cell.singleCharLabel.font = UIFont(name: UserProfile.activeFontName!, size: 30)
            cell.layer.cornerRadius = cell.layer.frame.height / 2
            cell.alpha = 0.7
        }
        return cell
    }

}