//
//  MainComment3.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-04-02.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//
import ChameleonFramework
import UIKit

class MainComment3: UITableViewCell {

    @IBOutlet weak var selfTextLabel: UILabel!
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var authorLabel: PaddingLabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
            
        case "dark":
            self.backgroundColor = FlatBlackDark()
            self.selfTextLabel.textColor = FlatWhite()

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
