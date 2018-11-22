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
        cell.textLabel?.text = user.name
        cell.imageView?.sd_setImage(with: user.photoURL, completed: nil)
        return cell
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
    
}
