//
//  AppDelegate.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-03.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Async
import SwiftyJSON
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(UIApplicationBackgroundFetchIntervalMinimum)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UserDefaults.standard.double(forKey: "downloadTime"))
        
        
        
//        // iOS 10 support
//        if #available(iOS 10, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//            application.registerForRemoteNotifications()
//        }
//            // iOS 9 support
//        else if #available(iOS 9, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//            // iOS 8 support
//        else if #available(iOS 8, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//            // iOS 7 support
//        else {  
//            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
//        }
        
        
        return true
    }

//    
//    
//    // Called when APNs has assigned the device a unique token
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        // Convert token to string
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        
//        // Print it to console
//        print("APNs device token: \(deviceTokenString)")
//        
//        // Persist it in your backend in case it's new
//    }
//    
//    // Called when APNs failed to register the device for push notifications
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        // Print the error to console (you should alert the user that registration failed)
//        print("APNs registration failed: \(error)")
//    }
//    
//    
//    // Push notification received
//    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
//        // Print notification payload data
//        print("Push notification received: \(data)")
//    }
//    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Entered BG")
        var bgTask = 0
        var app = UIApplication.shared
        bgTask = app.beginBackgroundTask(expirationHandler: {() -> Void in
            app.endBackgroundTask(bgTask)
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Send Notification (PUSH)
        print("bg")
        let nc = NotificationCenter.default
        let myNotification = Notification.Name(rawValue:"MyNotification")
        for subreddit in (UserDefaults.standard.object(forKey: "arrayOfSubreddits") as? [String])!{
        if Utils.hasAppropriateConnection() {
            Async.background {
                var arrayOfThreads:[ThreadData] = []
                Async.main {
                    var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
                    downloadsInProgress.append(subreddit)
                    UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")
                    
                    //Send notification that this subreddit is downloading (to produce overlay of ViewController)
                    nc.post(name:myNotification, object: nil, userInfo:["message":"", "date":Date()])
                }
                
                
                
                
                Downloader.downloadJSON(subreddit: subreddit)
                
                
                
                
                print("Getting subreddits")
                let jsonRaw = Downloader.getJSON(subreddit: subreddit, sortType: "Hot")
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
                             arrayOfThreads.append(thisThread)
                        }
                        print("Downloading threads")
                        var count = 1
                        //downloadCount = 0
                        downloadDictionary[subreddit] = 0
                        let numOfThreads = Int(UserDefaults.standard.string(forKey: "NumberOfThreads")!)
                        for thread in arrayOfThreads {
                            print("Downloading \(count)/\(numOfThreads!)")
                            count = count + 1
                            //print("Sending \(thread.id) to download")
                            Downloader.downloadThreadJSON(subreddit: subreddit, threadURL: thread.permalink, threadID: thread.id)
                        }
                        print("DOWNLOAD DISCTIONARY FOR \(subreddit) is \(downloadDictionary[subreddit])")
                        while downloadDictionary[subreddit]!/6 < arrayOfThreads.count {print("w")
                            sleep(1)}
                        
                        print("Done downloading.")
                        Async.main {
                            var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
                            
                            //Remove current subreddit from downloads in progress array
                            downloadsInProgress = downloadsInProgress.filter { $0 != subreddit }
                            UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")
                            
                            //Send notification again because the download has been completed
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
        
    completionHandler(.noData)
    }
    

}

