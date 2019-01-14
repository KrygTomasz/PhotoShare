//
//  PostTableViewCell.swift
//  PhotoShare
//
//  Created by Krygu on 09/01/2019.
//  Copyright © 2019 Krygu. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.bounds.width/2
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.borderColor = UIColor.white.cgColor
        
        postLabel.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
