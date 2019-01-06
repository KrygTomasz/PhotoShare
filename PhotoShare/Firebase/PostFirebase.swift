//
//  PostFirebase.swift
//  PhotoShare
//
//  Created by Krygu on 06/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import UIKit
import Firebase

class PostFirebase {
    
    class func createPost(image: UIImage, postText: String, completion: @escaping (Bool) -> Void) {
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let fileName = postRef.key ?? "" + ".jpg"
        let storageRef = Storage.storage().reference().child("postImages").child(fileName)
        guard
            let data = image.jpegData(compressionQuality: 0.75),
            let currentUser = Auth.auth().currentUser
        else {
            completion(false)
            return
        }
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error == nil {
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadUrl = url else {
                        completion(false)
                        return
                    }
                    let postObj: [String: Any] = [
                        "photoUrl": downloadUrl.absoluteString,
                        "postText": postText,
                        "userID": currentUser.uid,
                        "userPhotoUrl": currentUser.photoURL?.absoluteString ?? "",
                        "timeStamp": Date().timeIntervalSinceReferenceDate
                    ]
                    postRef.setValue(postObj)
                    completion(true)
                })
            } else {
                completion(false)
            }
        }
    }
    
}
