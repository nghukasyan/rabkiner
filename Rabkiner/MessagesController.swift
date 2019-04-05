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
                    
                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message
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
    
    func observeMessages(){
        let dbRef = Database.database().reference().child("messages")
        dbRef.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.fromId = dictionary["fromId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                message.toId = dictionary["toId"] as? String
//                self.messages.append(message)
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp!.int64Value > message2.timestamp!.int64Value
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
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
    
    func showInfo(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
                
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
