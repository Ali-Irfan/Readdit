//
//  SettingsHeaderTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework

class SettingsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var settingsImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
        setupTheme()
    }
    
    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!

        switch theme {
        case "default":
            settingsImage.setImage(settingsImage.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)
            
        default:
            settingsImage.setImage(settingsImage.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
