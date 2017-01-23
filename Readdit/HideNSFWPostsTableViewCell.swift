//
//  HideNSFWPostsTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-30.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class HideNSFWPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!

    @IBOutlet weak var nsfwSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchChanged(_ sender: Any) {
        
        if nsfwSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "hideNSFW")
            print("Hide NSFW = ON")
        } else {
            UserDefaults.standard.set(false, forKey: "hideNSFW")
            print("Hide NSFW = OFF")
        }
        
    }

    
}
