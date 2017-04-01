//
//  MainCommentCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-03-31.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit

class MainCommentCell: UITableViewCell {


    @IBOutlet weak var selftextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: PaddingLabel!
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var threadImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
