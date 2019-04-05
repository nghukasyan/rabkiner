//
//  NewMessageController.swift
//  Rabkiner
//
//  Created by MacBook Air on 3/29/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class NewMessageController: UITableViewController {

    var messageController: MessagesController?
    let cellId = "newMessageCell"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        fetchUserList()
    }
    func fetchUserList(){
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User()
                
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                print(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    } 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textField.text = user.name
        cell.detailTextField.text = user.email
        
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        // cell.textLabel?.text = user.name
        // style of the cell is not .Subtitle
        // cell.detailTextLabel?.text = user.email!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        let user = users[indexPath.row]
        self.messageController?.showChatLogController(forUser: user)
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
