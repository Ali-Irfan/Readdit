//
//  UpdateAllTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-01-16.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework

class UpdateAllTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var updateAll: UIButton!
    
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
            updateAll.setImage(updateAll.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)
            stopButton.setImage(stopButton.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)

            
        default:
            updateAll.setImage(updateAll.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)
            stopButton.setImage(stopButton.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
