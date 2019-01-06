//
//  ProfileVC.swift
//  PhotoShare
//
//  Created by Krygu on 20/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FBSDKLoginKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        profileImageView.sd_setImage(with: user?.photoURL, completed: nil)
        nameLabel.text = user?.displayName
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowLoginVC" {
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            UserFirebase.signOut()
            if navigationController?.tabBarController?.presentingViewController is LoginVC {
                navigationController?.tabBarController?.dismiss(animated: true, completion: nil)
                return false
            }
        }
        return true
    }

    @IBAction func viewPostsPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func createPostPressed(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let image = info[.originalImage] as? UIImage,
            let createPostVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC
            else {
                return
        }
        createPostVC.image = image
        picker.pushViewController(createPostVC, animated: true)
    }
    
}
