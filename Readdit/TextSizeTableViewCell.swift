//
//  TextSizeTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-30.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class TextSizeTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var textSizeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
