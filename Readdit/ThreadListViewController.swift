//
//  ThreadListViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-05.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenu

class ThreadListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayOfThreads: [ThreadData] = []
    var subreddit = ""
    

    
    var arrayOfSubreddits: [String] = ["AskReddit", "AskScience"]
    @IBOutlet weak var threadTable: UITableView!
    var jsonRaw = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(updateThreads))

        
       threadTable.delegate = self
        threadTable.dataSource = self
        threadTable.rowHeight = UITableViewAutomaticDimension
        threadTable.estimatedRowHeight = 140
        threadTable.backgroundColor = General.hexStringToUIColor(hex: "#dadada")
         jsonRaw = Downloader.getJSON(subreddit: subreddit)
        if (jsonRaw != "Error") {
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let threads = json["data"]["children"]
               // print(json)
                for (_, thread):(String, JSON) in threads {
                    let thisThread = ThreadData()
                    thisThread.title = thread["data"]["title"].string!
                    thisThread.author = thread["data"]["author"].string!
                    thisThread.upvotes = thread["data"]["ups"].int!
                    thisThread.commentCount = thread["data"]["num_comments"].int!
                    thisThread.id = thread["data"]["id"].string!
                    thisThread.permalink = thread["data"]["permalink"].string!
                    //print(title)
                    //print(thisThread)
                    arrayOfThreads.append(thisThread)
                }
               // print(arrayOfThreads)
                threadTable.reloadData()
                //updateThreads()
            }
            
            
            
            
        }
       // print(arrayOfThreads)
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func updateThreads() {
        for thread in arrayOfThreads {
            Downloader.downloadThreadJSON(threadURL: thread.permalink, threadID: thread.id)
            //print("Downloaded \(thread.id)")
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrayOfThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:THREADTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mycell2") as! THREADTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none; 
        
        cell.topViewBar.backgroundColor = General.hexStringToUIColor(hex: "#dadada")
        cell.mainText?.text = arrayOfThreads[indexPath.row].title
        cell.authorLabel?.text = "/u/" + arrayOfThreads[indexPath.row].author
        let dateText = General.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: Double(arrayOfThreads[indexPath.row].utcCreated)), numericDates: true)
        cell.hoursText?.text = " • " + String(arrayOfThreads[indexPath.row].upvotes)
        
        let firstWord   = dateText
        let secondWord = String(arrayOfThreads[indexPath.row].upvotes)
        let attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)]
        let attributedText = NSMutableAttributedString(string:firstWord)
        attributedText.append(NSMutableAttributedString(string: " • "))
        attributedText.append(NSAttributedString(string: secondWord, attributes: attrs))
        cell.hoursText?.attributedText = attributedText
        
        cell.textLabel?.numberOfLines=0;
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! THREADTableViewCell
        
        var threadURL = ""
        var threadID = ""
        
        if (jsonRaw != "Error") {
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let threads = json["data"]["children"]
                for (_, thread):(String, JSON) in threads {
                    let title = thread["data"]["title"]
                    if title.string! == currentCell.mainText?.text {
                        threadURL = ( thread["data"]["permalink"].string! )
                        threadID = thread["data"]["id"].string!
                    }
                }
            }

        let myVC = storyboard?.instantiateViewController(withIdentifier: "ThreadView") as! ThreadViewController
        myVC.threadURL = "https://reddit.com" + threadURL
            myVC.threadID = threadID
        navigationController?.pushViewController(myVC, animated: true)
    }
    }
    
    func sendAlert(TITLE:String, MESSAGE:String, BUTTON:String) {
        let alert = UIAlertController(title: TITLE, message: MESSAGE, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: BUTTON, style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

}
