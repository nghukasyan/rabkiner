//
//  UserCell.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/3/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
