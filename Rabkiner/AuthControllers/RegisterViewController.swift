//
//  RegisterViewController.swift
//  Rabkiner
//
//  Created by MacBook Air on 3/16/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
    }
    @IBAction func goToLoginPageAction(_ sender: Any) {
        //        let logVc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        //        navigationController?.popToRootViewController(animated: false)
        //        //navigationController?.dismiss(animated: false, completion: nil)
        //        //navigationController?.popViewController(animated: false)
        //        navigationController?.pushViewController(logVc!, animated: false)
    }
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Fill in all the fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        
        if(!email.isEmpty && !name.isEmpty && !password.isEmpty){
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                guard let uid = result?.user.uid else { return }
                
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
                let image = UIImage(named: "emb.png")
                if let uploadData = image?.jpegData(compressionQuality: 0.1){
                    
                    // 1)Putting image into storage
                    storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        // 2) Get the url of the image
                        storageRef.downloadURL(completion: { (url, err) in
                            if let err = err {
                                print(err)
                                return
                            }
                            
                            guard let url = url else { return }
                            // 3)Adding it into dbvalues
                            let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
                            
                            // 4) Adding user data into our db
                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        })
                    })
                }
            
            }
        } else{
             showAlert()
        }
        
        return true
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String : AnyObject]){
        let ref = Database.database().reference().child("users")
        ref.child(uid).updateChildValues(values)
        ref.child(uid).updateChildValues(values) { (err, ref) in
            if let err = err {
                print(err)
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
