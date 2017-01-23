//
//  THREADTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-05.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework

class THREADTableViewCell: UITableViewCell {

    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var hoursText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var seperatorGroupView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
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
