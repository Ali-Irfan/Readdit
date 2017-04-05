//
//  MainComment2.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-04-01.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit

class MainComment2: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var authorLabel: PaddingLabel!
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var threadImageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
