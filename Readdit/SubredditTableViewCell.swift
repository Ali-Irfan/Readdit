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

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var subredditTitle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.layoutMargins = UIEdgeInsets.zero
        loadingIndicator.isHidden = true
        updateButton.setImage(#imageLiteral(resourceName: "cloud-computing"), for: .normal)
        updateButton.frame = CGRect(x: self.frame.width-50, y: self.frame.height/2 - 12, width: 30, height: 30)
        updateButton.addTarget(self, action: #selector(updateSubreddit), for: .touchUpInside)
        updateButton.tintColor = UIColor.white
        deleteButton.tintColor = UIColor.white
//        deleteButton.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
//        deleteButton.frame = CGRect(x: 0, y: self.frame.height/2 - 12, width: 20, height: 20)
        
    }

    
    func updateSubreddit() {
        print("Updating subreddit")
        if Utils.hasAppropriateConnection() {
        Async.background {
            
        
        var arrayOfThreads:[ThreadData] = []
        let subreddit = self.subredditTitle.currentTitle!
        print("Downloading subreddits")
            
            Async.main {
            var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
            downloadsInProgress.append(subreddit)
            UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")
                let nc = NotificationCenter.default
                let myNotification = Notification.Name(rawValue:"MyNotification")
                
                nc.post(name:myNotification,
                        object: nil,
                        userInfo:["message":"Hello there!", "date":Date()])
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            self.updateButton.isHidden = true
            }
            
            
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
                var count = 1
                for thread in arrayOfThreads {
                    print("Downloading \(count)/\(UserDefaults.standard.string(forKey: "NumberOfThreads"))")
                    count = count + 1
                    Downloader.downloadThreadJSON(subreddit: subreddit, threadURL: thread.permalink, threadID: thread.id)
                }
                print("Done downloading.")
                Async.main {
                var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.updateButton.isHidden = false
                downloadsInProgress = downloadsInProgress.filter { $0 != subreddit }
                UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")
                    let nc = NotificationCenter.default
                    let myNotification = Notification.Name(rawValue:"MyNotification")

                    nc.post(name:myNotification,
                            object: nil,
                            userInfo:["message":"Hello there!", "date":Date()])                }
        }//ASYNC
        } else {
            
            Utils.displayTheAlert(targetVC: (UIApplication.shared.keyWindow?.rootViewController)!, title: "Error", message: "You need a valid internet connection to download threads.")
        }
    }
        }
    
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
