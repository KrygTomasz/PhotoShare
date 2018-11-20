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

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        profileImageView.sd_setImage(with: user?.photoURL, completed: nil)
        print("ASDASD")
        print(user?.photoURL?.absoluteString)
        nameLabel.text = user?.displayName
        
    }

}
