//
//  NumberOfThreadsTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-20.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class NumberOfThreadsTableViewCell: UITableViewCell {

    @IBOutlet weak var numberField: ThreadNumberField!
    override func awakeFromNib() {
        super.awakeFromNib()

        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(NumberOfThreadsTableViewCell.hoopla)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.done, target: self, action: #selector(NumberOfThreadsTableViewCell.boopla))
        ]
        
        numberToolbar.sizeToFit()
        
        numberField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
        
        // Initialization code
        if let x = UserDefaults.standard.string(forKey: "NumberOfThreads") {
            numberField.text = x
        } else {
            numberField.text = "30"
        }
    }
    func boopla () {
        numberField.resignFirstResponder()
    }
    
    func hoopla () {
        numberField.text=""
        numberField.resignFirstResponder()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
