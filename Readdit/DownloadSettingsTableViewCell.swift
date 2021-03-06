
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

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var downloadSettingsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let setting = UserDefaults().string(forKey: "network")
        print("CURRENT SETTING: \(setting)")
        if setting == "both" {
            downloadSettingsButton.setTitle("Wifi + Data", for: .normal)
        } else if setting == "wifi" {
            downloadSettingsButton.setTitle("Wifi Only", for: .normal)
        } else {
            downloadSettingsButton.setTitle("Data Only", for: .normal)
        }
        print("Just set it")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
