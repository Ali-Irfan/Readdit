//
//  AutoDownloadTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-01-08.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit

class AutoDownloadTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        if  let arr = UserDefaults.standard.object(forKey: "reminderDate") as? [String] {
        let h = arr[0]
        let a = arr[1]
        pickerButton.setTitle(h + " " + a, for: .normal)
        // Initialization code
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
