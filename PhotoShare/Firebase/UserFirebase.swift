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
                print(auth?.user.displayName ?? "")
                completion(true)
                //user is signed in
            }
        }
    }
    
    class func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
}
