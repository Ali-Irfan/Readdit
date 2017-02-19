//
//  SettingsHeaderTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework
import FontAwesomeKit

class SettingsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var settingsImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
        print("Waking from nib")
        let settingsImageIcon = FAKMaterialIcons.settingsIcon(withSize: 40)
        settingsImageIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        settingsImage.setAttributedTitle(settingsImageIcon?.attributedString(), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
