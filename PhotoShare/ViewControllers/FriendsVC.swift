//
//  FriendsVC.swift
//  PhotoShare
//
//  Created by Krygu on 21/11/2018.
//  Copyright © 2018 Krygu. All rights reserved.
//

import UIKit

class FriendsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchResultsVC()
        let searchController = UISearchController(searchResultsController: searchVC)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
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
