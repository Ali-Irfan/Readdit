//
//  MainComment4.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-04-01.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//
import ChameleonFramework

import UIKit

class MainComment4: UITableViewCell {
    
    @IBOutlet weak var authorLabel: PaddingLabel!
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
            
        case "dark":
            self.backgroundColor = FlatBlackDark()
            
            self.authorLabel.textColor = FlatWhite()
            self.titleLabel.textColor = FlatWhite()
            self.upvoteLabel.textColor = FlatWhite()
            
        default: break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
