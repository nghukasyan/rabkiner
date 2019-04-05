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
        
    }
    @IBAction func sendMessageAction(_ sender: Any) {
        if let messageText = messageTextField, let text = messageText.text, let user = user, let toId = user.id {
            
            let bdRef = Database.database().reference().child("messages")
            let childRef = bdRef.childByAutoId()
            
            let fromId = (Auth.auth().currentUser?.uid)!
            let timestamp:NSNumber = NSNumber(value: Date().timeIntervalSince1970)
            let values = ["text": text,"toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
            // childRef.updateChildValues(values)
            
            childRef.updateChildValues(values) { (error, ref) in
                if let err = error{
                    print(err)
                    return
                }
                
                guard let messageId = childRef.key else { return }
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(messageId)
                recipientUserMessagesRef.setValue(1)
            }
        }
    }
}
