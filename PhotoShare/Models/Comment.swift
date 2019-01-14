//
//  Comment.swift
//  PhotoShare
//
//  Created by Krygu on 10/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import Foundation

class Comment: HasTimestamp {
    
    let timestamp: Double
    let commentText: String
    let photoUrl: URL
    
    init?(commentDictionary: [String: Any]?) {
        guard
            let urlString = commentDictionary?["photoUrl"] as? String,
            let url = URL(string: urlString),
            let timestamp = commentDictionary?["timestamp"] as? Double,
            let commentText = commentDictionary?["commentText"] as? String
        else { return nil }
        self.timestamp = timestamp
        self.commentText = commentText
        self.photoUrl = url
    }
    
}
