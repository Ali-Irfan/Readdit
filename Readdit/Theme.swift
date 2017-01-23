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
    
    static func setSidebarTheme(color: UIColor, textColor: UIColor, table: UITableView, logo: UILabel? = nil, view: UIView) {
        table.backgroundColor = color
        mainTextColor = textColor
        mainCellColor = table.backgroundColor!
        view.backgroundColor = color
        logo?.textColor = textColor
    }
    
    static func setButtonColor(button: UIButton, color: UIColor) {
        
        if color == FlatWhite() {
            button.tintColor = FlatBlack()
        } else {
            button.tintColor = color
        }
        
    }
    
    
    static func getGeneralColor() -> UIColor{
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
            
        case "mint":
            return FlatMint()
            
        case "purple":
            return FlatPurple()
            
        case "magenta":
            return FlatMagenta()
            
        case "lime":
            return FlatLime()
            
        case "blue":
            return FlatSkyBlue()
            
        case "red":
            return FlatRed()
            
        case "dark":
            return FlatBlack()
            
        case "default":
            return FlatBlack()
            
        default:
            break
        }
        return FlatBlack()
    }
    
}
