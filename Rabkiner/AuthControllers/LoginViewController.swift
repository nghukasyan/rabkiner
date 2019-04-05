//
//  LoginViewController.swift
//  Rabkiner
//
//  Created by MacBook Air on 3/16/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    var messagesController: MessagesController?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.updateViewConstraints()
        
        
        passwordField.delegate = self
    }
    
    @IBAction func goToRegisterPageAction(_ sender: Any) {
        //        let regVc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
        //        navigationController?.popToRootViewController(animated: false)
        //        navigationController?.pushViewController(regVc!, animated: true)
    }

    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Fill in all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = emailField.text!
        let password = passwordField.text!
        
        if(!email.isEmpty && !password.isEmpty){
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error == nil{
                    //self.messagesController?.showInfo()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }else{
            showAlert()
        }
        
        
        return true
    }
    
}
