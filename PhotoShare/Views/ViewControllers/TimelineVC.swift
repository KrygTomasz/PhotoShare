//
//  TimelineVC.swift
//  PhotoShare
//
//  Created by Krygu on 09/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import UIKit

class TimelineVC: UITableViewController {

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(postNib, forCellReuseIdentifier: "PostTableViewCell")
        PostFirebase.getTimelinePosts { (post) in
            guard let post = post else { return }
            let indexPath = insertSortedByTimestamp(array: &self.posts, item: post)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension TimelineVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(indexPath: indexPath)
    }
    
}

extension TimelineVC {
    
    func configureCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = posts[indexPath.row]
        cell.postLabel.text = post.postText
        cell.postLabel.layer.cornerRadius = 8
        cell.postLabel.layer.masksToBounds = true
        cell.postImageView.sd_setImage(with: post.photoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.userImageView.sd_setImage(with: post.userPhotoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width/2
        cell.userImageView.layer.borderWidth = 3.0
        cell.userImageView.layer.borderColor = UIColor.white.cgColor
        cell.userImageView.layer.masksToBounds = true
        cell.selectionStyle = .none
        return cell
    }
    
}
