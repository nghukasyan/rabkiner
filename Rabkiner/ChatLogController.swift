//
//  ChatLogController.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/4/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UIViewController {

    var user: User? {
        didSet{
            self.navigationItem.title = user?.name
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.backgroundColor = UIColor.white
        
    }
    @IBAction func sendMessageAction(_ sender: Any) {
        if let messageText = messageTextField,let text = messageText.text,let user = user,let toId = user.id{
            let bdRef = Database.database().reference().child("messages")
            let childRef = bdRef.childByAutoId()
            let fromId = (Auth.auth().currentUser?.uid)!
            let timestamp:NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
            let values = ["text": text,"to": toId, "from": fromId, "timestamp": timestamp] as [String : Any]
            childRef.updateChildValues(values)
        }
    }
}
