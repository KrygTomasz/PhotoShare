//
//  PSUser.swift
//  PhotoShare
//
//  Created by Krygu on 22/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import Foundation

class PSUser {
    let name: String
    let photoURL: URL
    let userID: String
    
    init?(userDictionary: [String: Any]?) {
        guard
            let name = userDictionary?["name"] as? String,
            let stringURL = userDictionary?["photoURL"] as? String,
            let photoURL = URL(string: stringURL),
            let userID = userDictionary?["userID"] as? String
            else {
                return nil
        }
        self.name = name
        self.photoURL = photoURL
        self.userID = userID
    }
}
