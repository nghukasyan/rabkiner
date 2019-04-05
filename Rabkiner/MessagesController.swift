//
//  MessagesController.swift
//  Rabkiner
//
//  Created by MacBook Air on 3/29/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class MessagesController: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWhenLogin), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        showInfo()
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showNewMessageController))
        
        observeUserMessages()
    }
    
    @objc func updateWhenLogin(){
        showInfo()
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
    }
    
    func showInfo() {
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference().child("users").child(uid!)
        dbRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                
            }
        }
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let dbRef = Database.database().reference().child("user-messages").child(uid)
        
        dbRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messagesReference = Database.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let message = Message()
                    message.fromId = dictionary["fromId"] as? String
                    message.text = dictionary["text"] as? String
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    message.toId = dictionary["toId"] as? String
                    //                self.messages.append(message)
                    
                    if let partnerId = message.chatPartnerId() {
                        self.messagesDictionary[partnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1.timestamp!.int64Value > message2.timestamp!.int64Value
                        })
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            })
        }
    }

    
    @objc func showNewMessageController(){
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    func showChatLogController(forUser user: User){
        let chatLogController = storyboard?.instantiateViewController(withIdentifier: "ChatLogController") as? ChatLogController
        chatLogController!.user = user
        self.navigationController?.pushViewController(chatLogController!, animated: true)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else{return}
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            let user = User()
            user.id = chatPartnerId
            user.email = dictionary["email"] as? String
            user.name = dictionary["name"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            
            self.showChatLogController(forUser: user)
        }
    }
}
