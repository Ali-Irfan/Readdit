//
//  InitialViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-02-08.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import ChameleonFramework
import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var arrow: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 250
            view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            let revealController = self.revealViewController() as? RevealViewController
            revealController?.initialController = self
        }
        if Theme.getGeneralColor() != FlatBlack() {
            Utils.addMenuButton(color: FlatWhite(), navigationItem: (self.navigationItem), revealViewController: revealViewController())
        } else {
            Utils.addMenuButton(color: FlatBlack(), navigationItem: (self.navigationItem), revealViewController: revealViewController())
        }
        Theme.setNavbarTheme(navigationController: self.navigationController!, color: Theme.getGeneralColor())
        self.navigationItem.title = "Readdit"
        arrow.image = arrow.image!.maskWithColor(color: UIColor.lightGray)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
