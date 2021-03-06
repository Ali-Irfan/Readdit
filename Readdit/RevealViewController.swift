//
//  RevealViewControlle.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-19.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class RevealViewController: SWRevealViewController, SWRevealViewControllerDelegate {
 var settingsController: SettingsViewController!
    var threadsListController: ThreadListViewController!
    var initialController: InitialViewController!
        override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tapGestureRecognizer()
        self.panGestureRecognizer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - SWRevealViewControllerDelegate
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        if position == FrontViewPosition.right {
            self.frontViewController.view.isUserInteractionEnabled = false
        }
        else {
            self.frontViewController.view.isUserInteractionEnabled = true
        }
    }
    
}
