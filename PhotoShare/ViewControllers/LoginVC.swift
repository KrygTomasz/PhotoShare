//
//  LoginVC.swift
//  PhotoShare
//
//  Created by Krygu on 20/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
    }
    
}

//MARK: FBSDKLoginButtonDelegate
extension LoginVC: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (auth, error) in
            if let error = error {
                NSLog("Facebook logging error: \(error.localizedDescription)")
                return
            } else {
                print(auth?.user.displayName ?? "")
                //user is signed in
            }
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User has logged out")
    }
    
}
