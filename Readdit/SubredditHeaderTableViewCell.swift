//
//  SubredditHeaderTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import ChameleonFramework
import FontAwesomeKit
class SubredditHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var folderImage: UIButton!
    @IBOutlet weak var addSubreddit: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
        setupTheme()
        
        let plusCircle = FAKMaterialIcons.plusCircleOIcon(withSize: 50)
        plusCircle?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        addSubreddit.setAttributedTitle(plusCircle?.attributedString(), for: .normal)
        
    }
    
    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        
        switch theme {
        case "white":
            addSubreddit.setImage(addSubreddit.currentImage?.maskWithColor(color: FlatBlack())?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
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
