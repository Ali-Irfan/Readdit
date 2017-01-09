//
//  SidebarTableViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
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
        
        switch identifier {
        case "subredditHeader":
            let cell:SubredditHeaderTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subredditHeader") as! SubredditHeaderTableViewCell
           // cell.textSizeButton.addTarget(self, action: #selector(changeTextSize), for: .touchUpInside)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
