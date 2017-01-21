//
//  SubredditHeaderTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework

class SubredditHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var folderImage: UIButton!
    @IBOutlet weak var addSubreddit: UIButton!
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
            addSubreddit.setImage(addSubreddit.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)
            folderImage.setImage(folderImage.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)
            
            
        default:
            addSubreddit.setImage(addSubreddit.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)
            folderImage.setImage(folderImage.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
