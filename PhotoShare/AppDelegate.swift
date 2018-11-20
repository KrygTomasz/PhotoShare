//
//  AppDelegate.swift
//  PhotoShare
//
//  Created by Krygu on 20/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingVC")
        window?.rootViewController = loadingVC
        if FBSDKAccessToken.current() != nil {
            //goto home page
            UserFirebase.signIn(token: FBSDKAccessToken.current()) { (status) in
                if status {
                    let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                    self.window?.rootViewController = profileVC
                }
            }
        } else {
            //goto login page
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            window?.rootViewController = loginVC
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] as? String)
        return handled ?? false
    }

}

