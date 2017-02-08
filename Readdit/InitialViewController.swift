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

    override func viewDidLoad() {
        super.viewDidLoad()

        Utils.addMenuButton(color: FlatBlack(), navigationItem: self.navigationItem, revealViewController: revealViewController())
        
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
