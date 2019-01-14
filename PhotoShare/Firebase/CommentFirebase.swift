//
//  CommentFirebase.swift
//  PhotoShare
//
//  Created by Krygu on 14/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import Foundation
import Firebase

class CommentFirebase {
    
    static let postsRef = Database.database().reference().child("posts")
    
    class func createComment(commentText: String, postPhotoUrlString: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let commentObject: [String : Any] = [
            "timestamp": Date().timeIntervalSinceReferenceDate,
            "commentText": commentText,
            "photoUrl": currentUser.photoURL?.absoluteString ?? ""
        ]
        postsRef.queryOrdered(byChild: "photoUrl").queryEqual(toValue: postPhotoUrlString).observeSingleEvent(of: .value) { (snapshot) in
            guard let key = (snapshot.value as? [String: Any])?.keys.first else {
                completion(false)
                return
            }
            postsRef.child(key).child("comments").childByAutoId().setValue(commentObject)
        }
        completion(true)
    }
    
    class func getComments(postPhotoUrlString: String, completion: @escaping (Comment?) -> Void) {
        postsRef.queryOrdered(byChild: "photoUrl").queryEqual(toValue: postPhotoUrlString).observeSingleEvent(of: .value) { (snapshot) in
            guard let key = (snapshot.value as? [String: Any])?.keys.first else {
                completion(nil)
                return
            }
            postsRef.child(key).child("comments").observe(.childAdded, with: { (secondSnapshot) in
                let commentDictionary = secondSnapshot.value as? [String: Any]
                let comment = Comment(commentDictionary: commentDictionary)
                completion(comment)
            })
        }
    }
    
}
