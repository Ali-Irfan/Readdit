//
//  MainComment3.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-04-01.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit

class MainComment3: UITableViewCell {

    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var selfTextLabel: UILabel!
    @IBOutlet weak var authorLabel: PaddingLabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
