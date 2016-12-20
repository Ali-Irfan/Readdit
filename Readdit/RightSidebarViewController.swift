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
    let arrayOfSortings:[String] = ["Sort by", "Top", "Best", "New", "Old", "Controversial", "Old"]

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
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrayOfSortings.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        if indexPath.row > 0 {
            let currentCell = tableView.cellForRow(at: indexPath)! as! TypeOfSortCell
            print("Label: " + currentCell.mainTextLabel.text!)
            self.revealViewController().rightRevealToggle(animated: true)
        } else {
            let currentCell = tableView.cellForRow(at: indexPath)! as! MainSortCell
            print("Label: " + currentCell.mainTextLabel.text!)
            
        }

        
        

    }
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let sortType = arrayOfSortings[indexPath.row]
        
        if indexPath.row > 0 {
            let cell:TypeOfSortCell = sortingTable.dequeueReusableCell(withIdentifier: "sort")! as! TypeOfSortCell
            cell.mainTextLabel.text = sortType
            return cell
        } else {
            let cell:MainSortCell = sortingTable.dequeueReusableCell(withIdentifier: "sortBy") as! MainSortCell
            cell.mainTextLabel.text = "Sort By:"
            return cell
        }
            
    }



}
