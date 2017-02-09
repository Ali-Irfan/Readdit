
//
//  DarkModeTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-30.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var themeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
            let theme = UserDefaults.standard.string(forKey: "theme")!

            
            switch theme {
            case "mint":
                themeButton.setTitle("Mint", for: .normal)
            case "purple":
                themeButton.setTitle("Grape", for: .normal)
            case "magenta":
                themeButton.setTitle("Eggplant", for: .normal)
            case "lime":
                themeButton.setTitle("Lime", for: .normal)
            case "blue":
                themeButton.setTitle("Blueberry", for: .normal)
            case "red":
                themeButton.setTitle("Watermelon", for: .normal)
            case "dark":
                themeButton.setTitle("Night", for: .normal)
            default:
                print("Idk")
            }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
