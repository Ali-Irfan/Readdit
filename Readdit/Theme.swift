//
//  THEMES.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-01-18.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import Foundation


class Theme {
    static func setNavbarColor(navigationController: UINavigationController, color: UIColor) {
        navigationController.navigationBar.backgroundColor = color
        navigationController.navigationBar.tintColor = color
        navigationController.navigationBar.barTintColor = color
        navigationController.navigationBar.barStyle = .black
        navigationController.hidesNavigationBarHairline = true
    }
    
    
}
