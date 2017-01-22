//
//  THEMES.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-01-18.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import Foundation
import ChameleonFramework

class Theme {
    static func setNavbarTheme(navigationController: UINavigationController, color: UIColor) {
        navigationController.navigationBar.backgroundColor = color
        navigationController.navigationBar.tintColor = color
        navigationController.navigationBar.barTintColor = color
        if color == FlatWhite() {
            navigationController.navigationBar.barStyle = .default
            UIApplication.shared.statusBarStyle = .default

        } else {
            navigationController.navigationBar.barStyle = .black
            UIApplication.shared.statusBarStyle = .lightContent

        }
        navigationController.hidesNavigationBarHairline = true
    }
    
    static func setSidebarTheme(color: UIColor, textColor: UIColor, table: UITableView, logo: UILabel, view: UIView) {
        table.backgroundColor = color
        mainTextColor = textColor
        mainCellColor = table.backgroundColor!
        view.backgroundColor = color
        logo.textColor = textColor
    }
    
    static func setButtonColor(button: UIButton, color: UIColor) {
        
        if color == FlatWhite() {
            button.tintColor = FlatBlack()
        } else {
            button.tintColor = color
        }
        
    }
    
}
