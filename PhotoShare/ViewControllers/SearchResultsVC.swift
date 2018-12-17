//
//  SearchResultsVC.swift
//  PhotoShare
//
//  Created by Krygu on 22/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultsVC: UITableViewController {

    var results: [PSUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureCell(user: PSUser) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = user.name
        cell.imageView?.sd_setImage(with: user.photoURL, completed: nil)
        if user.isInvited {
            cell.accessoryView = UIImageView(image: UIImage(named: "invite+"))
        } else if user.isFriend {
            cell.accessoryView = UIImageView(image: UIImage(named: "friendsIcon"))
        }
        return cell
    }
    
    func createInviteAction(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Invite") { (action, view, completion) in
            UserFirebase.invite(userID: self.results[indexPath.row].userID) { status in
                if status {
                    let cell = self.tableView.cellForRow(at: indexPath)
                    cell?.accessoryView = UIImageView(image: UIImage(named: "invite+"))
                }
                completion(status)
            }
        }
        action.backgroundColor = .green
        action.image = UIImage(named: "invite+")
        return action
    }
    
    func createUninviteAction(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Uninvite") { (action, view, completion) in
            UserFirebase.uninvite(userID: self.results[indexPath.row].userID, completion: { status in
                if status {
                    let cell = self.tableView.cellForRow(at: indexPath)
                    cell?.accessoryView = nil
                }
                completion(status)
            })
        }
        action.backgroundColor = .red
        action.image = UIImage(named: "invite-")
        return action
    }
    
}

//MARK: UITableView delegates
extension SearchResultsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(user: results[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let inviteAction = createInviteAction(indexPath: indexPath)
        let inviteConfig = UISwipeActionsConfiguration(actions: [inviteAction])
        return inviteConfig
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uninviteAction = createUninviteAction(indexPath: indexPath)
        let uninviteConfig = UISwipeActionsConfiguration(actions: [uninviteAction])
        return uninviteConfig
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !results[indexPath.row].isFriend
    }
    
}
