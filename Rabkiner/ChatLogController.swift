//
//  ChatLogController.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/4/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UIViewController{
    
    let cellId = "cellId"

    var user: User? {
        didSet{
            self.navigationItem.title = user?.name
            
            observeMessages()
        }
    }

    var messages = [Message]()
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        
        userMessagesRef.observe(.childAdded) { (snapshot) in
            print(snapshot)
            let messageId = snapshot.key
            
            let messageRef = Database.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                
                let message = Message()
                // message.setValuesForKeys(dictionary)
                message.fromId = dictionary["fromId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                message.toId = dictionary["toId"] as? String

                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.messageCollection.reloadData()
                    }
                }
 
            })
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        messageCollection.dataSource = self
        messageCollection.delegate = self
        
        messageCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        messageCollection.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        messageCollection.alwaysBounceVertical = true
        messageCollection.backgroundColor = UIColor.white
        
        messageCollection.register(UINib(nibName: "MessageCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    @IBAction func sendMessageAction(_ sender: Any) {
        handleSend()
    }
    
    func handleSend(){
        if let messageText = messageTextField, let text = messageText.text, let user = user, let toId = user.id {
            
            let bdRef = Database.database().reference().child("messages")
            let childRef = bdRef.childByAutoId()
            
            let fromId = (Auth.auth().currentUser?.uid)!
            let timestamp:NSNumber = NSNumber(value: Date().timeIntervalSince1970)
            let values = ["text": text,"toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
            // childRef.updateChildValues(values)
            
            self.messageTextField.text = nil
        
            
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



extension ChatLogController: UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        messageCollection?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        //get estimated height somehow????
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        let message = messages[indexPath.item]
        cell.messageTextField.text = message.text
        
        setupCell(cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        
        return cell
    }
    
    func setupCell(_ cell: MessageCell, message: Message) {
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = MessageCell.blueColor
            cell.messageTextField.textColor = UIColor.white
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = MessageCell.lightGrayColor
            cell.messageTextField.textColor = UIColor.black
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
