//
//  UserInfoTableViewCell.swift
//  Alyssa
//
//  Created by Wenzheng Li on 1/2/16.
//  Copyright © 2016 Wenzheng Li. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var nickname : String? {
        get {
            return nicknameLabel.text
        }
        set {
            nicknameLabel.text = newValue
        }
    }
    
    var email : String? {
        get {
            return emailLabel.text
        }
        set {
            emailLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
