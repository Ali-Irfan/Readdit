//
//  ScheduleViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-19.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {

            view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 250
            let btn1 = UIButton(type: .custom)
            btn1.setImage(#imageLiteral(resourceName: "menu-2"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
            btn1.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            navigationItem.leftBarButtonItem = item1
        }
        
        
        
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
