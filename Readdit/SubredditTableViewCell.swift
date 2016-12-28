//
//  SubredditTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Async

class SubredditTableViewCell: UITableViewCell {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var subredditTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateButton.setImage(#imageLiteral(resourceName: "cloud-computing"), for: .normal)
        updateButton.frame = CGRect(x: self.frame.width-50, y: self.frame.height/2 - 12, width: 30, height: 30)
        updateButton.addTarget(self, action: #selector(updateSubreddit), for: .touchUpInside)
    }

    func updateSubreddit() {
        
        if Utils.hasAppropriateConnection() {
        Async.background {
            
        self.updateButton.isEnabled = false
        var arrayOfThreads:[ThreadData] = []
        let subreddit = self.subredditTitle.text!
        print("Downloading subreddits")
        
        Downloader.downloadJSON(subreddit: subreddit)
            
        print("Getting subreddits")
        let jsonRaw = Downloader.getJSON(subreddit: subreddit, sortType: "Top")
        arrayOfThreads.removeAll()
        if (jsonRaw != "Error") {
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let threads = json["data"]["children"]
                for (_, thread):(String, JSON) in threads {
                    let thisThread = ThreadData()
                    thisThread.title = thread["data"]["title"].string!
                    thisThread.author = thread["data"]["author"].string!
                    thisThread.upvotes = thread["data"]["ups"].int!
                    thisThread.commentCount = thread["data"]["num_comments"].int!
                    thisThread.id = thread["data"]["id"].string!
                    thisThread.nsfw = Bool(thread["data"]["over_18"].boolValue)
                    thisThread.permalink = thread["data"]["permalink"].string!
                    
                    if let key = UserDefaults.standard.object(forKey: "hideNSFW") as? Bool { //Key exists
                        
                        if !key {
                            arrayOfThreads.append(thisThread)
                        }
                        
                    } else { //Default is not hiding
                        arrayOfThreads.append(thisThread)
                    }
                }
                print("Downloading threads")
                for thread in arrayOfThreads {
                    
                    Downloader.downloadThreadJSON(subreddit: subreddit, threadURL: thread.permalink, threadID: thread.id)
                }
                print("Done downloading.")
                self.updateButton.isEnabled = true
            }
        }
        }//ASYNC
        } else {
            
            Utils.displayTheAlert(targetVC: (UIApplication.shared.keyWindow?.rootViewController)!, title: "Error", message: "You need a valid internet connection to download threads.")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
