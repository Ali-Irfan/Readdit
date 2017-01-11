//
//  SidebarTableViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import Async
var arrayOfSubreddits: [String] = ["AskReddit", "AskScience", "IAmA", "News", "ExplainLikeImFive", "Jokes", "NSFW"]

class SidebarTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arrayOfIdentifiers: [String] = []
    var numberOfSubreddits = 0

    
    func getSubreddits() -> [String] {
        return arrayOfSubreddits
    }
    
    @IBOutlet weak var sidebarTable: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("View did load (front)")
        
        self.sidebarTable.dataSource = self
        self.sidebarTable.delegate = self
        sidebarTable.estimatedRowHeight = 250.0
        sidebarTable.rowHeight = UITableViewAutomaticDimension
        sidebarTable.allowsSelection = true
        


        
        
        arrayOfIdentifiers.append("subredditHeader")
        for _ in arrayOfSubreddits {
            arrayOfIdentifiers.append("subreddit")
            numberOfSubreddits = numberOfSubreddits + 1
        }
        
        arrayOfIdentifiers.append("settingsHeader")

    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt
indexPath: IndexPath){

        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        if let currentCell = tableView.cellForRow(at: indexPath)! as? SubredditTableViewCell{ //IF ITS A SUBREDDIT
            print("Here")
            let subreddit = (currentCell.subredditTitle.text)
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ThreadNavigation") as! ThreadNavigationController
            let actualView = myVC.viewControllers.first as! ThreadListViewController
            actualView.subreddit = subreddit!
            //present(myVC, animated: true, completion: nil)
             self.revealViewController().pushFrontViewController(myVC, animated: true)
        } else if tableView.cellForRow(at: indexPath)! is SettingsHeaderTableViewCell {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as! UINavigationController
            self.revealViewController().pushFrontViewController(myVC, animated: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfIdentifiers.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = arrayOfIdentifiers[indexPath.row]
        
        sidebarTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        print("Doing cell for row at \(identifier)")
        switch identifier {
        case "subredditHeader":
            let cell:SubredditHeaderTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subredditHeader") as! SubredditHeaderTableViewCell
            cell.addSubreddit.addTarget(self, action: #selector(addSubreddit), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case "subreddit":
            let cell:SubredditTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subreddit") as! SubredditTableViewCell
            cell.subredditTitle.text? = arrayOfSubreddits[indexPath.row-1]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        case "settingsHeader":
            let cell:SettingsHeaderTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "settingsHeader") as! SettingsHeaderTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell

        default:
            let cell:UITableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "settingsCell")! as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        }
    }
    
    func addSubreddit() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Subreddit", message: "Enter a subreddit name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "e.g. AskReddit"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let subredditToAdd = textField?.text?.trimmingCharacters(in: .whitespaces).capitalizingFirstLetter()
            if subredditToAdd != "" && !arrayOfSubreddits.contains(subredditToAdd!) {
                arrayOfSubreddits.append(subredditToAdd!)
                self.arrayOfIdentifiers.insert("subreddit", at: self.arrayOfIdentifiers.count-1)
                self.sidebarTable.reloadData()
                Async.main{
                    // First figure out how many sections there are
                    let lastSectionIndex = self.sidebarTable!.numberOfSections - 1
                    
                    // Then grab the number of rows in the last section
                    let lastRowIndex = self.sidebarTable!.numberOfRows(inSection: lastSectionIndex) - 1
                    
                    // Now just construct the index path
                    
                    let pathToLastRow = NSIndexPath(row: lastRowIndex-1, section: lastSectionIndex)
                    
                    if let cell = self.sidebarTable.cellForRow(at: pathToLastRow as IndexPath) as? SubredditTableViewCell {
                        cell.updateSubreddit()
                    }
                }
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }




}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
