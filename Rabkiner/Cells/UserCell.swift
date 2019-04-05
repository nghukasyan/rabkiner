//
//  UserCell.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/3/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class UserCell: UITableViewCell {

    var message: Message? {
        didSet {
            
            setupNameAndProfileImage()
            detailTextField.text = message?.text
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
        }
    }
    
    func setupNameAndProfileImage(){
        let chatPartnerId: String?
        
        if message?.fromId == Auth.auth().currentUser?.uid{
            chatPartnerId = message?.toId
        } else {
            chatPartnerId = message?.fromId
        }
        
        if let id = chatPartnerId {
            let dbRef = Database.database().reference().child("users").child(id)
            dbRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textField.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                    
                }
            }
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var detailTextField: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
