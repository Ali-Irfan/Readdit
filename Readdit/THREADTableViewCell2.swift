//
//  THREADTableViewCell2.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-04-02.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework

class THREADTableViewCell2: UITableViewCell {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hoursText: UILabel!
    @IBOutlet weak var topViewBar: UIView!

    @IBOutlet weak var threadImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var mainText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
            
        case "dark":
            self.backgroundColor = FlatBlackDark()
            self.topViewBar.backgroundColor = FlatBlack()
            
            self.authorLabel.textColor = FlatWhite()
            self.mainText.textColor = FlatWhite()
            self.hoursText.textColor = FlatWhite()
            
        default:
            self.topViewBar.backgroundColor = FlatWhite()
        }
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
