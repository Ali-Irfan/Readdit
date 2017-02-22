//
//  InitialViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2017-02-08.
//  Copyright © 2017 Ali Irfan. All rights reserved.
//

import ChameleonFramework
import UIKit

class InitialViewController: UIViewController {
    let defaults = UserDefaults.standard
    var themeColor:UIColor = FlatSkyBlue()
    @IBOutlet weak var arrow: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set([], forKey: "inProgress")
        if defaults.string(forKey: "firstTime") == "false" {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ThreadNavigation") as! ThreadNavigationController
            let actualView = myVC.viewControllers.first as! ThreadListViewController
            let arrayOfSubreddits = defaults.object(forKey: "arrayOfSubreddits") as! [String]
            if let lastSubreddit = defaults.string(forKey: "lastClickedSubreddit") {

                if arrayOfSubreddits.contains(lastSubreddit) {
                    actualView.subreddit = lastSubreddit
                } else {
                    if arrayOfSubreddits.count > 0 {
                    actualView.subreddit = arrayOfSubreddits[0]
                    }
                }
                print("last subreddit was \(lastSubreddit)")
            } else {
                if let firstSubreddit = (defaults.object(forKey: "arrayOfSubreddits") as? [String])?[0] {
                    actualView.subreddit = firstSubreddit
                }
            }
            self.revealViewController().pushFrontViewController(myVC, animated: true)
            return //Go to first subreddit instead of this one
        }

        
        setDefaults()
        //Reset current downloads
        
        
        for subreddit in (defaults.object(forKey: "arrayOfSubreddits") as? [String])! {
            downloadDictionary[subreddit] = 0
        }

        
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 250
            view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            let revealController = self.revealViewController() as? RevealViewController
            revealController?.initialController = self
        }
        if Theme.getGeneralColor() != FlatWhite() {
            Utils.addMenuButton(color: FlatWhite(), navigationItem: (self.navigationItem), revealViewController: revealViewController())
        } else {
            Utils.addMenuButton(color: FlatBlack(), navigationItem: (self.navigationItem), revealViewController: revealViewController())
        }
        
        Theme.setNavbarTheme(navigationController: self.navigationController!, color: Theme.getGeneralColor())
        self.navigationItem.title = "Readdit"
        arrow.image = arrow.image!.maskWithColor(color: UIColor.lightGray)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
        /*Sets defaults for UserDefault values used throughout app*/
        func setDefaults() {
    
            let obj: [String] = []
            defaults.set(obj, forKey: "inProgress")
    
    
            if defaults.object(forKey: "arrayOfSubreddits") != nil {} else {
                let defaultSubreddits: [String] = ["AskReddit", "AskScience", "IAmA", "News", "ExplainLikeImFive", "Jokes", "NSFW"]
                defaults.set(defaultSubreddits, forKey: "arrayOfSubreddits")
            }
            
            if defaults.string(forKey: "firstTime") != nil {}  else { defaults.set("false", forKey: "firstTime") }
            
            if defaults.string(forKey: "reminderDate") != nil {} else {    defaults.set(["Disabled", "AM"], forKey: "network")}
            if defaults.string(forKey: "network") != nil {print("its not nil")} else {         defaults.set("wifi", forKey: "network");print("it was nil")}
            if defaults.object(forKey: "downloadTime") != nil {} else {    defaults.set(0, forKey: "downloadTime")}
            if defaults.object(forKey: "NumberOfThreads") != nil {} else { defaults.set("10", forKey: "NumberOfThreads")}
            if defaults.object(forKey: "fontSize") != nil {} else {        defaults.set("regular", forKey: "fontSize")}
            
            if defaults.object(forKey: "theme") != nil {} else {           defaults.set("blue", forKey: "theme")}
            if defaults.object(forKey: "themeBlue") != nil {} else {       defaults.set(0.860000014305115, forKey: "themeBlue")}
            if defaults.object(forKey: "themGreen") != nil {} else {       defaults.set(0.598560035228729, forKey: "themeGreen")}
            if defaults.object(forKey: "themeRed") != nil {} else {        defaults.set(0.206400007009506, forKey: "themeRed")}
        
        }

    
    

}
