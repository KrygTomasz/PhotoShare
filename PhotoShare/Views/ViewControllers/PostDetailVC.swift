//
//  PostDetailVC.swift
//  PhotoShare
//
//  Created by Krygu on 10/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import UIKit
import SDWebImage

class PostDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField! {
        didSet {
            commentTextField.delegate = self
        }
    }
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    
    var post: Post?
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(postNib, forCellReuseIdentifier: "PostTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:         UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:         UIResponder.keyboardWillHideNotification, object: nil)
        
        CommentFirebase.getComments(postPhotoUrlString: post?.photoUrl.absoluteString ?? "") { (comment) in
            guard let comment = comment else { return }
            let indexPath = insertSortedReversedByTimestamp(array: &self.comments, item: comment)
            let correctedIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            self.tableView.insertRows(at: [correctedIndexPath], with: .fade)
            let lastIndexPath = IndexPath(row: self.comments.count, section: 0)
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        let height = keyboardRect.height
        commentBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        commentBottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        CommentFirebase.createComment(commentText: commentTextField.text ?? "", postPhotoUrlString: post?.photoUrl.absoluteString ?? "") { (status) in
            if status {
                self.commentTextField.text = ""
            }
            sender.isEnabled = true
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PostDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return configurePostCell(indexPath: indexPath)
        default:
            return configureCommentCell(indexPath: indexPath)
        }
    }
    
}

extension PostDetailVC {
    
    func configurePostCell(indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell,
            let post = post
        else { return UITableViewCell() }
        cell.postImageView.sd_setImage(with: post.photoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.userImageView.sd_setImage(with: post.userPhotoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.postLabel.text = post.postText
        cell.selectionStyle = .none
        return cell
    }
    
    func configureCommentCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let comment = comments[indexPath.row-1]
        cell.imageView?.sd_setImage(with: comment.photoUrl, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.textLabel?.text = comment.commentText
        cell.selectionStyle = .none
        return cell
    }
    
}

extension PostDetailVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
