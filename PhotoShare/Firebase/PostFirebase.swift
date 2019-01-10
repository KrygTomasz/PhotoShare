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
    
    static let usersRef = Database.database().reference().child("users")
    static let postsRef = Database.database().reference().child("posts")
    
    class func createPost(image: UIImage, postText: String, completion: @escaping (Bool) -> Void) {
        let postRef = postsRef.childByAutoId()
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
    
    class func get(userID: String, completion: @escaping (Post?) -> Void) {
        postsRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observe(.childAdded) { (snapshot) in
            let postDictionary = snapshot.value as? [String: Any]
            let post = Post(postDictionary: postDictionary)
            completion(post)
        }
    }
    
    class func getTimelinePosts(completion: @escaping (Post?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        postsRef.queryOrdered(byChild: "userID").queryEqual(toValue: currentUser.uid).observe(.childAdded, with: { (snapshot) in
            let postDictionary = snapshot.value as? [String: Any]
            let post = Post(postDictionary: postDictionary)
            completion(post)
        })
        usersRef.child(currentUser.uid).child("friends").observe(.childAdded) { (snapshot) in
            guard
                let userObject = snapshot.value as? [String: Any],
                let userID = userObject["userID"] as? String
            else {
                completion(nil)
                return
            }
            postsRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observe(.childAdded, with: { (snapshot) in
                let postDictionary = snapshot.value as? [String: Any]
                let post = Post(postDictionary: postDictionary)
                completion(post)
            })
        }
    }
    
}
