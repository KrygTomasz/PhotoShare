//
//  CreatePostVC.swift
//  PhotoShare
//
//  Created by Krygu on 06/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import UIKit

class CreatePostVC: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.image = image
        postTextView.becomeFirstResponder()
    }
    
    @IBAction func createPostPressed(_ sender: UIButton) {
        sender.isEnabled = false
        PostFirebase.createPost(image: image, postText: postTextView.text) { (status) in
            sender.isEnabled = true
            if status {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
