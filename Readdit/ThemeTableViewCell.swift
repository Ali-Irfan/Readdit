
//
//  DarkModeTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-30.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var themeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        themeButton.setTitle(UserDefaults.standard.string(forKey: "theme"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
