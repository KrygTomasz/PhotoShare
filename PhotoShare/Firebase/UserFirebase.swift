//
//  UserFirebase.swift
//  PhotoShare
//
//  Created by Krygu on 20/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class UserFirebase {
    
    static let usersRef = Database.database().reference().child("users")
    
    class func signIn(result: FBSDKLoginManagerLoginResult!, completion: @escaping (Bool) -> Void) {
        let credential = FacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        signIn(credential: credential, completion: completion)
    }
    
    class func signIn(token: FBSDKAccessToken, completion: @escaping (Bool) -> Void) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        signIn(credential: credential, completion: completion)
    }
    
    private class func signIn(credential: AuthCredential, completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAndRetrieveData(with: credential) { (auth, error) in
            if let error = error {
                NSLog("Facebook logging error: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                storeUser(user: auth?.user)
                completion(true)
                //user is signed in
            }
        }
    }
    
    private class func storeUser(user: User?) {
        guard let user = user else { return }
        usersRef.child(user.uid).child("name").setValue(user.displayName)
        usersRef.child(user.uid).child("photoURL").setValue(user.photoURL?.absoluteString ?? "")
        usersRef.child(user.uid).child("userID").setValue(user.uid)
    }
    
    class func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    class func searchUsers(with text: String?, completion: @escaping ([PSUser]) -> Void) {
        guard
            let text = text,
            let currentUser = Auth.auth().currentUser
        else {
            completion([])
            return
        }
        usersRef.queryOrdered(byChild: "name").queryStarting(atValue: text).queryEnding(atValue: text + "~").observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            var optionalUserDicts: [[String: Any]?] = []
            while let child = enumerator.nextObject() as? DataSnapshot {
                let userDict = child.value as? [String: Any]
                optionalUserDicts.append(userDict)
            }
            let foundUsers = optionalUserDicts.flatMap({ (userDictionary) -> PSUser? in
                let user = PSUser.init(userDictionary: userDictionary)
                if
                    let invites = userDictionary?["invites"] as? [String: Any],
                    invites.keys.contains(currentUser.uid) {
                        user?.isInvited = true
                }
                return user
            })
            completion(foundUsers)
        }
    }
    
    class func invite(userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        let userObject: [String: String] = [
            "name": currentUser.displayName ?? "",
            "photoURL": currentUser.photoURL?.absoluteString ?? "",
            "userID": currentUser.uid
        ]
        usersRef.child(userID).child("invites").child(currentUser.uid).setValue(userObject)
        completion(true)
    }
    
    class func uninvite(userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        usersRef.child(userID).child("invites").child(currentUser.uid).setValue(nil)
        completion(true)
    }
    
    class func observeUsers(type: String, event: DataEventType, completion: @escaping (PSUser?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        usersRef.child(user.uid).child(type).observe(event) { (snapshot) in
            let userDictionary = snapshot.value as? [String: Any]
            let userObj = PSUser.init(userDictionary: userDictionary)
            completion(userObj)
        }
    }
    
    class func acceptInvite(userObject: PSUser, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        usersRef.child(user.uid).child("invites").child(userObject.userID).setValue(nil)
        let userDictionary: [String : Any] = [
            "name": userObject.name,
            "photoURL": userObject.photoURL.absoluteString,
            "userID": userObject.userID
        ]
        usersRef.child(user.uid).child("friends").child(userObject.userID).setValue(userDictionary)
        let currentUserDictionary: [String : Any] = [
            "name": user.displayName ?? "",
            "photoURL": user.photoURL?.absoluteString ?? "",
            "userID": user.uid
        ]
        usersRef.child(userObject.userID).child("friends").child(user.uid).setValue(currentUserDictionary)
        completion(true)
    }
    
    class func declineInvite(userObject: PSUser, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        usersRef.child(user.uid).child("invites").child(userObject.userID).setValue(nil)
        completion(true)
    }
    
}
