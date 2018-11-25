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
        guard let text = text else {
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
                PSUser.init(userDictionary: userDictionary)
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
    
}
