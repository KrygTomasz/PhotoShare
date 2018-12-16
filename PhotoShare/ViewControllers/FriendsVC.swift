//
//  FriendsVC.swift
//  PhotoShare
//
//  Created by Krygu on 21/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import UIKit

class FriendsVC: UITableViewController {

    var dataModel: [[PSUser]] = [[], []]
    let titles = ["Invitations", "Friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchResultsVC()
        let searchController = UISearchController(searchResultsController: searchVC)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        UserFirebase.observeUsers(type: "invites", event: .childAdded) { (user) in
            guard let user = user else { return }
            self.dataModel[0].insert(user, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        }
        UserFirebase.observeUsers(type: "invites", event: .childRemoved) { (user) in
            guard
                let user = user,
                let index = self.dataModel[0].firstIndex(where: { (anotherUser) -> Bool in
                    return user.userID == anotherUser.userID
                }) else {
                    return
            }
            self.dataModel[0].remove(at: index)
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        UserFirebase.observeUsers(type: "friends", event: .childAdded) { (user) in
            guard let user = user else { return }
            self.dataModel[0].insert(user, at: 0)
            let indexPath = IndexPath(row: 0, section: 1)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        }
        UserFirebase.observeUsers(type: "friends", event: .childRemoved) { (user) in
            guard
                let user = user,
                let index = self.dataModel[0].firstIndex(where: { (anotherUser) -> Bool in
                    return user.userID == anotherUser.userID
                }) else {
                    return
            }
            self.dataModel[1].remove(at: index)
            let indexPath = IndexPath(row: index, section: 1)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension FriendsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        print(searchText ?? "")
        UserFirebase.searchUsers(with: searchText) { users in
            if let searchResultsVC = searchController.searchResultsController as? SearchResultsVC {
                searchResultsVC.results = users
                searchResultsVC.tableView.reloadData()
            }
        }
    }
}

extension FriendsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
}

extension FriendsVC {
    func configureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = dataModel[indexPath.section][indexPath.row]
        cell.imageView?.sd_setImage(with: user.photoURL, placeholderImage: UIImage(named: "photo"), options: [], completed: nil)
        cell.textLabel?.text = user.name
        return cell
    }
}
