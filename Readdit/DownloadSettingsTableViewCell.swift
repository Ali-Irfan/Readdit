
//
//  DownloadSettingsTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-30.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import Foundation

class DownloadSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!

    @IBOutlet weak var downloadSettingsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let setting = UserDefaults().string(forKey: "network")
        if setting == "both" {
            downloadSettingsButton.setTitle("WiFi + Data", for: .normal)
        } else if setting == "wifi" {
            downloadSettingsButton.setTitle("WiFi Only", for: .normal)
        } else {
            downloadSettingsButton.setTitle("Data Only", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
