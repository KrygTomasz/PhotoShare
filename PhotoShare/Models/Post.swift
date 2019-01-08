//
//  Post.swift
//  PhotoShare
//
//  Created by Krygu on 08/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import Foundation

class Post: HasTimestamp {
    
    let photoUrl: URL
    let userPhotoUrl: URL
    let postText: String
    let timestamp: Double
    
    init?(postDictionary: [String: Any]?) {
        guard
            let urlString = postDictionary?["photoUrl"] as? String,
            let url = URL(string: urlString),
            let userUrlString = postDictionary?["userPhotoUrl"] as? String,
            let userUrl = URL(string: userUrlString),
            let postText = postDictionary?["postText"] as? String,
            let timestamp = postDictionary?["timeStamp"] as? Double
        else { return nil }
        self.photoUrl = url
        self.userPhotoUrl = userUrl
        self.postText = postText
        self.timestamp = timestamp
    }
    
}
