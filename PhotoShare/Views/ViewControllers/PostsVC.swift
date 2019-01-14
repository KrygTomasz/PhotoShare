//
//  PostsVC.swift
//  PhotoShare
//
//  Created by Krygu on 06/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"

class PostsVC: UICollectionViewController {
    
    var userDisplayName: String?
    var userID: String = ""
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (userDisplayName ?? "User") + "'s Posts"
        
        PostFirebase.get(userID: userID) { (post) in
            guard let post = post else { return }
            let indexPath = insertSortedByTimestamp(array: &self.posts, item: post)
            self.collectionView.insertItems(at: [indexPath])
        }
    }
    
}

extension PostsVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCell(indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let postDetailVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailVC") as? PostDetailVC else { return }
        postDetailVC.post = posts[indexPath.item]
        postDetailVC.modalTransitionStyle = .crossDissolve
        self.present(postDetailVC, animated: true, completion: nil)
    }
    
}

extension PostsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3
        let height = collectionView.bounds.width / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension PostsVC {
    
    func configureCell(indexPath: IndexPath) -> UICollectionViewCell {
        let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyPostCell", for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return emptyCell
        }
        let post = posts[indexPath.item]
        cell.postImageView.sd_setImage(with: post.photoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        return cell
    }
    
}
