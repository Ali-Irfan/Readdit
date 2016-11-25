//
//  ViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-03.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayOfSubreddits: [String] = ["AskReddit", "AskScience", "IAmA", "News", "ExplainLikeImFive", "Jokes"]

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var txtSubreddit: UITextField!


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        for subreddit in arrayOfSubreddits {
            Downloader.downloadJSON(subreddit: subreddit)
            print("Downloading \(subreddit)")
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrayOfSubreddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text = arrayOfSubreddits[indexPath.row]
        //cell.detailTextLabel?.text="subtitle#\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayOfSubreddits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.table.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        let subreddit = currentCell.textLabel?.text
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ThreadList") as! ThreadListViewController
        myVC.subreddit = subreddit!
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    
    @IBAction func addSubreddit(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            if (txtSubreddit.text != nil && txtSubreddit.text != ""){
                var subreddit = txtSubreddit.text!.capitalized
                 subreddit = subreddit.replacingOccurrences(of: " ", with: "")
                arrayOfSubreddits.append(subreddit)
                self.table.reloadData()
                txtSubreddit.text = ""
                Downloader.downloadJSON(subreddit: subreddit)
                //print("Sent " + subreddit + " to DownloaderJSON")
            }
        } else {
            print("Internet connection FAILED")
            sendAlert(TITLE: "No Internet Connection", MESSAGE: "Make sure your device is connected to the internet to initially add subreddits!", BUTTON: "OK")
        }
    }

    
    @IBAction func downloadSubreddits(_ sender: Any) {
        print("Clicked")
        for subreddit in arrayOfSubreddits {
            Downloader.downloadJSON(subreddit: subreddit)
            print("Downloading \(subreddit)")
        }
    }

    
    func sendAlert(TITLE:String, MESSAGE:String, BUTTON:String) {
        let alert = UIAlertController(title: TITLE, message: MESSAGE, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: BUTTON, style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    

    
    
    
    
    }
    




