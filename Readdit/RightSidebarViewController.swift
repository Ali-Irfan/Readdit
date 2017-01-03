//
//  RightSidebarViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-19.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class RightSidebarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sortingTable: UITableView!
    let defaults = UserDefaults.standard
    let arrayOfThreadSortings:[String] = ["Top", "New", "Controversial", "Best", "Old", "QA"]
    let arrayOfSubredditSortings:[String] = ["Hot", "Controversial", "Top", "Rising", "New"]
    var currentSortingStyle:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortingTable.dataSource = self
        sortingTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let currentNavigationView = self.revealViewController().frontViewController as! UINavigationController
        let currentThreadView = currentNavigationView.visibleViewController
        if (currentThreadView?.isKind(of: ThreadViewController.self))! {
        currentSortingStyle = arrayOfThreadSortings
        } else if (currentThreadView?.isKind(of: ThreadListViewController.self))!{
        currentSortingStyle = arrayOfSubredditSortings
        }
        sortingTable.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSortingStyle.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        if indexPath.row >= 0 {
            let currentCell = tableView.cellForRow(at: indexPath)! as! TypeOfSortCell
            print("Label: " + currentCell.mainTextLabel.text!)
            self.revealViewController().rightRevealToggle(animated: true)
            //INSERT LOCAL SORT HERE
           
            let currentNavigationView = self.revealViewController().frontViewController as! UINavigationController
            let currentThreadView = currentNavigationView.visibleViewController
            if (currentThreadView?.isKind(of: ThreadViewController.self))! {
                let vc = currentThreadView as! ThreadViewController
                vc.sortBy(sortType: currentCell.mainTextLabel.text!)
            } else if (currentThreadView?.isKind(of: ThreadListViewController.self))!{
                print("Was not on the correct VC")
            }
            
            
            

            
        } else {
            let currentCell = tableView.cellForRow(at: indexPath)! as! TypeOfSortCell
            print("Label: " + currentCell.mainTextLabel.text!)
            
        }

        
        

    }
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var sortType = ""
        sortType = currentSortingStyle[indexPath.row]
            let cell:TypeOfSortCell = sortingTable.dequeueReusableCell(withIdentifier: "sort")! as! TypeOfSortCell
            cell.mainTextLabel.text = sortType
            return cell

            
    }

}
