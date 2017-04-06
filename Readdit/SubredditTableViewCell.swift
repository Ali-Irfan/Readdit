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
import Alamofire
import ChameleonFramework
import FontAwesomeKit

var downloadCount = 1
var downloadsAreStopped:Bool = false

class SubredditTableViewCell: UITableViewCell {
    
    let nc = NotificationCenter.default

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var subredditTitle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.layoutMargins = UIEdgeInsets.zero
       // loadingIndicator.isHidden = true
        //deleteButton.setImage(#imageLiteral(resourceName: "minus").withRenderingMode(.alwaysTemplate), for: .normal)
        
        //updateButton.setImage(#imageLiteral(resourceName: "update"), for: .normal)
        
        let updateCircle = FAKMaterialIcons.refreshIcon(withSize: 30)
        updateCircle?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        updateButton.setAttributedTitle(updateCircle?.attributedString(), for: .normal)
        
        let deleteImage = FAKMaterialIcons.deleteIcon(withSize: 35)
        deleteImage?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        deleteButton.setAttributedTitle(deleteImage?.attributedString(), for: .normal)
        
        updateButton.frame = CGRect(x: self.frame.width-50, y: self.frame.height/2 - 12, width: 30, height: 30)
        updateButton.addTarget(self, action: #selector(updateSubreddit), for: .touchUpInside)
        updateButton.tintColor = UIColor.white
        deleteButton.tintColor = UIColor.white
        
        //        deleteButton.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
        //        deleteButton.frame = CGRect(x: 0, y: self.frame.height/2 - 12, width: 20, height: 20)
        setupTheme()
        
    }
    
    
    
    
    func setupTheme(){
        self.backgroundColor = UIColor.clear
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
        case "white":
            updateButton.setImage(updateButton.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)
            deleteButton.setImage(deleteButton.currentImage?.maskWithColor(color: FlatBlack()), for: .normal)
            
        default:
            updateButton.setImage(updateButton.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)
            deleteButton.setImage(deleteButton.currentImage?.maskWithColor(color: FlatWhite()), for: .normal)
        }
        
    }
    
    
    func updateSubreddit(updatingAll:Bool = false) {

        downloadsAreStopped = false
        var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]

        let subreddit = self.subredditTitle.currentTitle!
        if Utils.hasAppropriateConnection(updatingAll: updatingAll) {
            print("Updating..")
            Async.main {
                downloadsInProgress.append(subreddit)
                UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")
                
                //Send notification that this subreddit is downloading (to produce overlay of ViewController)
                self.nc.post(name:updateViewNotification, object: nil, userInfo:["message":"", "date":Date()])
            }
            
            Async.background {
                var arrayOfThreads:[ThreadData] = []
                
                //Delete all current items before you download the new batch
                do {
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let subredditPath = documentsPath.appendingPathComponent(subreddit)
                    try FileManager.default.removeItem(at: subredditPath!)
                } catch let error as NSError {
                    print("An error took place(UpdateSubreddit): \(error)")
                }

                
                
                Downloader.downloadJSON(subreddit: subreddit)
                
                
                
                
                //print("Getting subreddits")
                let jsonRaw = Downloader.getJSON(subreddit: subreddit, sortType: "Hot")
                
                if (jsonRaw != "Error") {
                    //print(jsonRaw)
                    
                    arrayOfThreads.removeAll()
                    if let data = jsonRaw.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        let numOfThreads:Int = Int(UserDefaults.standard.string(forKey: "NumberOfThreads")!)!
                        var threadCount = 0
                        let threads = json["data"]["children"]
                        
                        for (_, thread):(String, JSON) in threads {
                            if threadCount < numOfThreads {
                            let thisThread = ThreadData()
                            thisThread.title = thread["data"]["title"].string!
                            thisThread.author = thread["data"]["author"].string!
                            thisThread.upvotes = thread["data"]["ups"].int!
                            thisThread.commentCount = thread["data"]["num_comments"].int!
                            thisThread.id = thread["data"]["id"].string!
                            thisThread.nsfw = Bool(thread["data"]["over_18"].boolValue)
                            thisThread.permalink = thread["data"]["permalink"].string!
                            arrayOfThreads.append(thisThread)
                            }
                            
                            threadCount = threadCount + 1
                        }
                        print("Downloading threads")
                        var count = 1
                        //downloadCount = 0
                        downloadDictionary[subreddit] = 0
                        print("Number of threads : \(numOfThreads)")
                        print("arrayofthreadcount: \(arrayOfThreads.count)")
                        
                        var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
                        

                        
                            for thread in arrayOfThreads {

                                print("Downloading \(count)/\(numOfThreads)")
                                count = count + 1
                                //print("Sending \(thread.id) to download")
                                if !downloadsAreStopped {
                                Downloader.downloadThreadJSON(subreddit: subreddit, threadURL: thread.permalink, threadID: thread.id)
                                }
                            }
                        
                        Async.main {
                            //Remove current subreddit from downloads in progress array
                            downloadsInProgress = downloadsInProgress.filter { $0 != subreddit }
                            UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")
                            
                            //Send notification again because the download has been completed
                            self.nc.post(name:updateViewNotification,
                                    object: nil,
                                    userInfo:["message":"Hello there!", "date":Date()])
                            
                        }
                    }
                    
                } else {
                    
                    Utils.displayTheAlert(targetVC: (UIApplication.shared.keyWindow?.rootViewController)!, title: "Error", message: "You need a valid internet connection to download threads.")
                }
            }
        }
        
    }




    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    }

