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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let postDetailVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailVC") as? PostDetailVC else { return }
        postDetailVC.post = posts[indexPath.row]
        postDetailVC.modalTransitionStyle = .crossDissolve
        self.present(postDetailVC, animated: true, completion: nil)
    }
    
}

extension TimelineVC {
    
    func configureCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = posts[indexPath.row]
        cell.postLabel.text = post.postText
        cell.postImageView.sd_setImage(with: post.photoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.userImageView.sd_setImage(with: post.userPhotoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)

        cell.selectionStyle = .none
        return cell
    }
    
}
