//
//  UpdateAllTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-01-16.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit

class UpdateAllTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var updateAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
