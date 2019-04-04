//
//  ProfileViewController.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/1/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

//
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func changeProfileImage(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
                profileImage.image = selectedImage
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            // UIImagePNGRepresentation(UIImage) replaced by UIImage method pngData()
            // instead of image.pngData() we use image.jpegData(compressionQuality: 0.1)
            if let image = self.profileImage.image, let uploadData = image.jpegData(compressionQuality: 0.1){
                storageRef.putData(uploadData)
                    
                storageRef.putData(uploadData, metadata: nil) { (_, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                        
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        guard let url = url else { return }
                        let uid = Auth.auth().currentUser?.uid
                        let ref = Database.database().reference().child("users")
                        ref.child(uid!).child("profileImageUrl").setValue(url.absoluteString)
                    })
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("c")
        picker.dismiss(animated: true, completion: nil)
    }
}
