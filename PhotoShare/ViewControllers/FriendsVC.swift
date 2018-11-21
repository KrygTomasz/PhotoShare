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
        
        let vc = UIViewController()
        let searchController = UISearchController(searchResultsController: vc)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
    }

}

extension FriendsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        print(searchText ?? "")
    }
}
