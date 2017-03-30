//
//  SidebarTableViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-06.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//
import ChameleonFramework
import UIKit
import Async
import PMAlertController
import Alamofire
import FontAwesomeKit


var arrayOfSubreddits = UserDefaults.standard.object(forKey: "arrayOfSubreddits") as! [String]
var mainTextColor = UIColor()
var mainCellColor = UIColor()

class SidebarTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var logo: UILabel!
    var otherView = UIView() //Top Fade
    var otherOtherView = UIView() //Bottom fade
    
    @IBOutlet weak var settingsButtonIcon: UIButton!
    @IBOutlet weak var addASubreddit: UIButton!
    
    @IBOutlet weak var bottomColorView: UIView!
    @IBOutlet weak var updateAllIcon: UIButton!
    @IBOutlet weak var updateAllButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var arrayOfIdentifiers: [String] = []
    var numberOfSubreddits = 0
    
    
    func getSubreddits() -> [String] {
        return arrayOfSubreddits
    }

    
    @IBOutlet weak var testNotif: UIButton!
    
    @IBAction func testNotification(_ sender: Any) {
    
        let notification = UILocalNotification()
        //sender.setTitle("Not Manual", for: .normal)
        
        /* Time and timezone settings */
        notification.fireDate = NSDate(timeIntervalSinceNow: 8.0) as Date
        notification.timeZone = NSCalendar.current.timeZone
        notification.alertBody = "Reminder: Click here to update your subreddits!"
        notification.soundName = UILocalNotificationDefaultSoundName
        /* Action settings */
        notification.hasAction = true
        notification.alertAction = "View"
        
        /* Additional information, user info */
        notification.userInfo = [
            "Key 1" : "Value 1",
            "Key 2" : "Value 2"
        ]
        
        /* Schedule the notification */
        UIApplication.shared.scheduleLocalNotification(notification)

    
    
    }
    
   
    
    @IBOutlet weak var sidebarTable: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //THIS IS JUST SO I CAN SEE IT WITHOUT THE TEST
        testNotif.isHidden = true
        //END OF SHOWING TEST NOTIFICATION
        
        addASubreddit.layer.cornerRadius = 5
        addASubreddit.addTarget(self, action: #selector(addSubreddit), for: .touchUpInside)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:updateSubredditNotification, object:nil, queue:nil, using:updateAllSubredditsWithoutAlert)
        nc.addObserver(forName:updateViewNotification,      object:nil, queue:nil, using:checkCurrentDownloads)
        
        self.sidebarTable.dataSource = self
        self.sidebarTable.delegate = self
        sidebarTable.estimatedRowHeight = 250.0
        sidebarTable.rowHeight = UITableViewAutomaticDimension
        sidebarTable.allowsSelection = true
        sidebarTable.contentInset = UIEdgeInsetsMake(15, 0, 0, 0) //Lower it a little for the fade
        
        
        settingsButton.addTarget(self, action: #selector(goToSubreddit(_:)), for: .touchUpInside)
        settingsButton.backgroundColor = ClearColor()
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        let settingsImageIcon = FAKMaterialIcons.settingsIcon(withSize: 35)
        settingsImageIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        settingsButtonIcon.setAttributedTitle(settingsImageIcon?.attributedString(), for: .normal)
        
        let stopButtonIcon = FAKMaterialIcons.timeRestoreIcon(withSize: 35)
        stopButtonIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        updateAllIcon.setAttributedTitle(stopButtonIcon?.attributedString(), for: .normal)
        updateAllButton.addTarget(self, action: #selector(updateAllSubredditsSelector), for: .touchUpInside)
        

        
        for _ in arrayOfSubreddits {
            arrayOfIdentifiers.append("subreddit")
            numberOfSubreddits = numberOfSubreddits + 1
        }
        
        setupTheme()

        otherView =  UIView(frame: CGRect(x: sidebarTable.frame.origin.x, y: sidebarTable.frame.origin.y, width: sidebarTable.frame.width, height: 15))
        
        otherView.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: otherView.bounds, colors: [Theme.getGeneralDarkColor(), Theme.getGeneralDarkColor().withAlphaComponent(0)])
        
        self.view.addSubview(otherView)
        
        otherOtherView =  UIView(frame: CGRect(x: sidebarTable.frame.origin.x, y: sidebarTable.frame.origin.y+sidebarTable.frame.height-17, width: sidebarTable.frame.width, height:15))
        
    
        
        //otherOtherView.backgroundColor = FlatRed()
        otherOtherView.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: otherOtherView.bounds, colors: [Theme.getGeneralDarkColor().withAlphaComponent(0), Theme.getGeneralDarkColor()])
        
        self.view.addSubview(otherOtherView)
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupTheme()
        checkCurrentDownloads()
        addASubreddit.backgroundColor = Theme.getGeneralColor()
        addASubreddit.setTitleColor(FlatWhite(), for: .normal)
        
        for cell in sidebarTable.visibleCells { //For theme
            cell.awakeFromNib()
        }
        print(NSStringFromClass(revealViewController().frontViewController.classForCoder))
        if revealViewController().frontViewController.isKind(of: SidebarTableViewController.self) {
            let vc = revealViewController().frontViewController as! SidebarTableViewController
            let btn1 = UIButton(type: .custom)
            
            btn1.setImage(#imageLiteral(resourceName: "menu-2").maskWithColor(color: mainTextColor), for: .normal)
            btn1.frame = CGRect(x: 15, y: 45 , width: 36, height: 36)
            btn1.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            vc.view.addSubview(btn1)
        }
    
        bottomColorView.backgroundColor = Theme.getGeneralColor()
        otherView.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: otherView.bounds, colors: [Theme.getGeneralDarkColor(), Theme.getGeneralDarkColor().withAlphaComponent(0)])

        otherOtherView.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: otherOtherView.bounds, colors: [Theme.getGeneralDarkColor().withAlphaComponent(0), Theme.getGeneralDarkColor()])
        
        
    }
    
    func catchNotification(notification:Notification) -> Void {
        checkCurrentDownloads()
    }
    
    func catchNotification2(notification:Notification) -> Void {
        updateAllSubreddits()
    }
    
    func checkCurrentDownloads(notification:Notification? = nil) -> Void {
        let downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
        for cell in sidebarTable.visibleCells {
            if let c = cell as? SubredditTableViewCell {
                let subreddit = c.subredditTitle.currentTitle!
                if downloadsInProgress.contains(subreddit) {
                    c.loadingIndicator.startAnimating()
                    c.loadingIndicator.isHidden = false
                    c.deleteButton.isEnabled = false
                    c.updateButton.isHidden = true
                    
                } else {
                    c.loadingIndicator.stopAnimating()
                    c.loadingIndicator.isHidden = true
                    c.deleteButton.isEnabled = true
                    c.updateButton.isHidden = false
                }
            }
        }
    }
    

    
    
    
    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
        case "mint":
            
            let color = FlatMintDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "purple":
            let color = FlatPurpleDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "magenta":
            let color = FlatMagentaDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "lime":
            let color = FlatLimeDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "blue":
            
            let color = FlatSkyBlueDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "red":
            
            let color = FlatRedDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "dark":
            
            let color = FlatBlackDark()
            let textColor = FlatWhite()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        case "white":
            
            let color = FlatWhite()
            let textColor = FlatBlack()
            Theme.setSidebarTheme(color: color, textColor: textColor, table: sidebarTable, logo: self.logo, view: self.view)
            
        default:
            break
        }
        self.sidebarTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
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

        case "subreddit":
            let cell:SubredditTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subreddit") as! SubredditTableViewCell
            cell.subredditTitle.setTitle(arrayOfSubreddits[indexPath.row], for: .normal)
            cell.deleteButton.addTarget(self, action: #selector(deleteSubreddit(_:)), for: .touchUpInside)
            cell.subredditTitle.addTarget(self, action: #selector(goToSubreddit(_:)), for: .touchUpInside)
            cell.subredditTitle.setTitleColor(mainTextColor, for: .normal)
            cell.backgroundColor = mainCellColor
            return cell
        default:
            let cell:UITableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subreddit")! as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        }
    }
    
    @IBAction func clickedUpdateButtonImage(_ sender: Any) {
        updateAllButton.sendActions(for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func clickedSettingsIconButton(_ sender: Any) {
        settingsButton.sendActions(for: UIControlEvents.touchUpInside)

    }

    
    func updateAllSubredditsSelector() {
        updateAllSubreddits()
    }
    
    func updateAllSubredditsWithoutAlert(notification: Notification?) {
        updateAllSubreddits(showAlert: false)
    }

    
    func segueToSubreddits() {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "Subreddits") as! SidebarTableViewController
        self.revealViewController().pushFrontViewController(myVC, animated: true)
    }
    
    func updateAllSubreddits(notification:Notification?=nil, showAlert:Bool?=true) -> Void {
        if !showAlert! {
            for cell in self.sidebarTable.visibleCells {
                if let subredditCell = cell as? SubredditTableViewCell {
                    subredditCell.updateSubreddit(updatingAll: true)
                }
            }
            
        } else {
            
            
        let alert = PMAlertController(title: "Update all subreddits", color: Theme.getGeneralColor(), description: "This may take a while. Are you sure?", image: nil, style: .alert)
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(PMAlertAction(title: "Update", style: .default, color: Theme.getGeneralColor(), action: { () in
            for cell in self.sidebarTable.visibleCells {
                if let subredditCell = cell as? SubredditTableViewCell {
                    subredditCell.updateSubreddit(updatingAll: true)
                }
            }
            alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, color: Theme.getGeneralColor()))
            
            
        }))
            
    
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        }
    }

    
    func deleteSubreddit(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? SubredditTableViewCell {
            
            //Have to add in delete files too
            
            
            //1. Create the alert controller.
            
            let alert = PMAlertController(title: "Remove Subreddit", color: Theme.getGeneralColor(), description: "Are you sure you want to remove /r/\(cell.subredditTitle.currentTitle!)?", image: nil, style: .alert)
            alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, color: Theme.getGeneralColor()))
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(PMAlertAction(title: "Remove", style: .cancel, color: Theme.getGeneralColor(), action: { () in
                print(cell.subredditTitle.currentTitle!)
                arrayOfSubreddits = arrayOfSubreddits.filter() { $0 != cell.subredditTitle.currentTitle! }
                UserDefaults.standard.set(arrayOfSubreddits, forKey: "arrayOfSubreddits")
                self.arrayOfIdentifiers.remove(at: self.arrayOfIdentifiers.count-1)
                do {
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let subredditPath = documentsPath.appendingPathComponent(cell.subredditTitle.currentTitle!)
                    try FileManager.default.removeItem(at: subredditPath!)
                } catch let error as NSError {
                    print("An error took place(DownloadThread): \(error)")
                }
                
                self.sidebarTable.reloadData()
                if let frontView = self.revealViewController().frontViewController as? ThreadNavigationController {
                    if let firstView = frontView.viewControllers.first as? ThreadListViewController {
                        firstView.deletedOverlay.isHidden = false
                    }
                }
                
            }))
            
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func goToSubreddit(_ sender: UIButton) {
        if let currentCell = sender.superview?.superview as? SubredditTableViewCell{ //IF ITS A SUBREDDIT
            let subreddit = (currentCell.subredditTitle.currentTitle!)
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ThreadNavigation") as! ThreadNavigationController
            let actualView = myVC.viewControllers.first as! ThreadListViewController
            UserDefaults.standard.set(subreddit, forKey: "lastClickedSubreddit")
            print("Set last subreddit to \(subreddit)")
            actualView.subreddit = subreddit
            //present(myVC, animated: true, completion: nil)
            self.revealViewController().pushFrontViewController(myVC, animated: true)
        } else if sender.currentTitle == "Settings" {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as! UINavigationController
            self.revealViewController().pushFrontViewController(myVC, animated: true)
        }
    }
    
    
    func addSubreddit() {
        
        
        let alert = PMAlertController(title: "Add Subreddit", color: Theme.getGeneralColor(), description: "Enter a subreddit name", image: nil, style: .alert)
        
        
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField!.text = ""
            textField!.placeholder = "e.g. AskReddit"
            textField!.becomeFirstResponder()
        }
        
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(PMAlertAction(title: "Add", style: .default, color: Theme.getGeneralColor(), action: { () in
            let textField = alert.textFields[0] // Force unwrapping because we know it exists.
            
            let subredditToAdd = textField.text?.stringByRemovingWhitespaces.capitalizingFirstLetter()
            if subredditToAdd != "" && !arrayOfSubreddits.contains(where: {$0.caseInsensitiveCompare(subredditToAdd!) == .orderedSame}) && !(subredditToAdd?.contains("+"))!{
                arrayOfSubreddits.append(subredditToAdd!)
                UserDefaults.standard.set(arrayOfSubreddits, forKey: "arrayOfSubreddits")
                self.arrayOfIdentifiers.insert("subreddit", at: self.arrayOfIdentifiers.count)
                self.sidebarTable.reloadData()
                Async.main{
                    for cell in self.sidebarTable.visibleCells {
                        if let c = cell as? SubredditTableViewCell {
                            if c.subredditTitle.currentTitle == subredditToAdd! {
                                c.updateSubreddit()
                            }
                        }
                    }
                }
            }
            
        }))
        alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, color: Theme.getGeneralColor()))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}


