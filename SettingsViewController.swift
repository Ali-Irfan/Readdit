import UIKit
import SwiftyJSON
import ChameleonFramework
import Async
import PMAlertController
import XLActionController
import ActionSheetPicker_3_0


var downloadDictionary:[String:Int] = [:]

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var themeColor:UIColor = FlatSkyBlue()
    let arrayOfSettings = ["Text Size", "Download Settings", "Download Automatically", "Threads per Subreddit", "Theme", "Clear All Data"]
    @IBOutlet weak var settingsTable: UITableView!
    
    var totalSize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
        setupTheme()
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 250
                view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            let revealController = self.revealViewController() as? RevealViewController
                revealController?.settingsController = self
            }
        
        for subreddit in (defaults.object(forKey: "arrayOfSubreddits") as? [String])! {
            downloadDictionary[subreddit] = 0
            }

        
        //Temporarily stop logging visual errors
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        settingsTable.dataSource = self
        settingsTable.delegate = self
        settingsTable.rowHeight = 75.0
        settingsTable.allowsSelection = false
    }
    
    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        let n = navigationController!
        
        switch theme {
        case "mint":
            themeColor = FlatMint()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        case "purple":
            themeColor = FlatPurple()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        case "magenta":
            themeColor = FlatMagenta()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        case "lime":
            themeColor = FlatLime()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        case "blue":
            themeColor = FlatSkyBlue()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        case "red":
            themeColor = FlatRed()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        case "dark":
            themeColor = FlatBlack()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatBlack()
            self.view.backgroundColor = FlatBlack()
        case "white":
            themeColor = FlatWhite()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.black, navigationItem: navigationItem, revealViewController: revealViewController())
            settingsTable.backgroundColor = FlatWhite()
        default:
            print("Idk")
        }
        self.settingsTable.reloadData()
    }
    
    
    
    /*Sets defaults for UserDefault values used throughout app*/
    func setDefaults() {
       
        let obj: [String] = []
        defaults.set(obj, forKey: "inProgress")
        
        
        if defaults.object(forKey: "arrayOfSubreddits") != nil {} else {
            let defaultSubreddits: [String] = ["AskReddit", "AskScience", "IAmA", "News", "ExplainLikeImFive", "Jokes", "NSFW"]
            defaults.set(defaultSubreddits, forKey: "arrayOfSubreddits")
        }
        
        
        if defaults.string(forKey: "network") != nil {} else {         defaults.set("wifi", forKey: "network")}
        if defaults.object(forKey: "downloadTime") != nil {} else {    defaults.set(0, forKey: "downloadTime")}
        if defaults.object(forKey: "NumberOfThreads") != nil {} else { defaults.set("10", forKey: "NumberOfThreads")}
        if defaults.object(forKey: "fontSize") != nil {} else {        defaults.set("regular", forKey: "fontSize")}
        if defaults.object(forKey: "theme") != nil {} else {           defaults.set("white", forKey: "theme")}
        if defaults.object(forKey: "themeBlue") != nil {} else {       defaults.set(FlatWhite().getRGBAComponents()?.blue, forKey: "themeBlue")}
        if defaults.object(forKey: "themGreen") != nil {} else {       defaults.set(FlatWhite().getRGBAComponents()?.green, forKey: "themGreen")}
        if defaults.object(forKey: "themeRed") != nil {} else {        defaults.set(FlatWhite().getRGBAComponents()?.red, forKey: "themeRed")}
    
    }

    
    
    /*Setup action sheet to show options for network download settings*/
    func changeDownload(_ sender: UIButton!) {

        let optionMenu = SkypeActionController()
        
        let dataOnly = Action("Data Only", style: .default, handler: { action in
            sender.setTitle("Data Only", for: .normal)
            print("Data Only")
            self.defaults.set("data", forKey: "network")
        })
        
        let wifiOnly = Action("Wi-Fi Only", style: .default, handler: { action in
            sender.setTitle("Wi-Fi Only", for: .normal)
            print("Wi-Fi Only")
            self.defaults.set("wifi", forKey: "network")
        })

        let both = Action("Both", style: .default, handler: { action in
            sender.setTitle("Data + WiFi", for: .normal)
            self.defaults.set("both", forKey: "network")
            print("Both")
        })
        
        let cancelAction = Action("Cancel", style: .default, handler: { action in
            print("Cancelled")
        })
        
        optionMenu.addAction(dataOnly)
        optionMenu.addAction(wifiOnly)
        optionMenu.addAction(both)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    
    func changeTextSize(_ sender: UIButton!) {
        let optionMenu = SkypeActionController()
        
        let large = Action("Large", style: .default, handler: { action in
            print("Clicked large")
            sender.setTitle("Large", for: .normal)
            self.defaults.set("large", forKey: "fontSize")
        })
        
        let regular = Action("Regular", style: .default, handler: { action in
            sender.setTitle("Regular", for: .normal)
            self.defaults.set("regular", forKey: "fontSize")
        })
        
        let small = Action("Small", style: .default, handler: { action in
            sender.setTitle("Small", for: .normal)
            self.defaults.set("small", forKey: "fontSize")
        })
        
        let cancelAction = Action("Cancel", style: .cancel, handler: { action in
            print("Cancelled")
        })
        
        optionMenu.addAction(large)
        optionMenu.addAction(regular)
        optionMenu.addAction(small)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    
    func getNextDate() -> Date {
        let arr = UserDefaults.standard.object(forKey: "reminderDate") as! [String]
        var h = arr[0]
        let a = arr[1]
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        
        if a == "PM" {
            if Int(h)! > 12 {
                let intOfHour = Int(h)! + 12
                h = String(intOfHour)
            }
        }
        
        let date10h = calendar.date(bySettingHour: Int(h)!, minute: 0, second: 0, of: now as Date, options: NSCalendar.Options.matchFirst)!
        return date10h
    }
    func changeDownloadTimes(_ sender: UIButton!) {
        
        let optionMenu = SkypeActionController()
        
        let manual = Action("Manual", style: .default, handler: { action in
            sender.setTitle("Manually Download", for: .normal)
            self.defaults.set(0, forKey: "downloadTime")
        })
        
        let daily = Action("Daily", style: .default, handler: { action in
            sender.setTitle("Daily at h A", for: .normal)
            let notification = UILocalNotification()
            
            /* Time and timezone settings */
            notification.fireDate = self.getNextDate()//NSDate(timeIntervalSinceNow: 8.0) as Date
            notification.repeatInterval = NSCalendar.Unit.hour
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
        })
        
        let cancelAction = Action("Cancel", style: .cancel, handler: { action in
            print("Cancelled")
        })

        optionMenu.addAction(manual)
        optionMenu.addAction(daily)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func changeTheme(_ sender: UIButton) {
        //let optionMenu = UIAlertController(title: nil, message: "Choose Theme", preferredStyle: .actionSheet)
        let optionMenu = SkypeActionController()
        // 2
        let defaultTheme = Action("Diary", style: .default, handler: { action in
            sender.setTitle("Diary", for: .normal)
            self.defaults.set("white", forKey: "theme")
            
            self.defaults.set(FlatWhite().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatWhite().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatWhite().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let mint = Action("Mint", style: .default, handler: { action in
            sender.setTitle("Mint", for: .normal)
            self.defaults.set("mint", forKey: "theme")
            self.defaults.set(FlatMint().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatMint().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatMint().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let purple = Action("Grape", style: .default, handler: { action in
            sender.setTitle("Grape", for: .normal)
            self.defaults.set("purple", forKey: "theme")
            self.defaults.set(FlatPurple().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatPurple().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatPurple().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let lime = Action("Lime", style: .default, handler: { action in
            sender.setTitle("Lime", for: .normal)
            self.defaults.set("lime", forKey: "theme")
            self.defaults.set(FlatLime().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatLime().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatLime().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let magenta = Action("Eggplant", style: .default, handler: { action in
            sender.setTitle("Eggplant", for: .normal)
            self.defaults.set(FlatMagenta().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatMagenta().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatMagenta().getRGBAComponents()?.green, forKey: "themeGreen")
            self.defaults.set("magenta", forKey: "theme")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        
        let blue = Action("blue", style: .default, handler: { action in
            sender.setTitle("Blueberry", for: .normal)
            self.defaults.set("blue", forKey: "theme")
            self.defaults.set(FlatSkyBlue().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatSkyBlue().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatSkyBlue().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        //
        let red = Action("Watermelon", style: .default, handler: { action in
            sender.setTitle("Watermelon", for: .normal)
            self.defaults.set("red", forKey: "theme")
            self.defaults.set(FlatRed().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatRed().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatRed().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
            
        })
        
        let dark = Action("Dark Mode", style: .default, handler: { action in
            sender.setTitle("Dark Mode", for: .normal)
            self.defaults.set("dark", forKey: "theme")
            self.defaults.set(FlatBlack().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatBlack().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatBlack().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        
        
        let cancelAction = Action("Cancel", style: .cancel, handler: { action in
            print("Cancelled")
        })
        
        optionMenu.addAction(defaultTheme)
        optionMenu.addAction(blue)
        optionMenu.addAction(mint)
        optionMenu.addAction(purple)
        optionMenu.addAction(lime)
        optionMenu.addAction(magenta)
        optionMenu.addAction(red)
        optionMenu.addAction(dark)
        optionMenu.addAction(cancelAction)
        
        // 5
        
        present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrayOfSettings.count
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let setting = arrayOfSettings[indexPath.row]
        
        //Sets up each individual setting TableViewCell
        switch setting {
        case "Text Size":
            let cell:TextSizeTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "TextSize") as! TextSizeTableViewCell
            cell.textSizeButton.addTarget(self, action: #selector(changeTextSize), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.textSizeButton, color: themeColor)
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.textSizeButton.tintColor = FlatWhite()
                cell.mainLabel.textColor = FlatWhite()
            } else {
                cell.view.backgroundColor = UIColor.white
                cell.backgroundColor = FlatWhite()
                cell.textSizeButton.tintColor = FlatBlack()
                cell.mainLabel.textColor = FlatBlack()
            }
            
            return cell
        case "Theme":
            let cell:ThemeTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "Theme") as! ThemeTableViewCell
            cell.themeButton.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.themeButton, color: themeColor)
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.themeButton.tintColor = FlatWhite()
                cell.mainLabel.textColor = FlatWhite()
            } else {
                cell.view.backgroundColor = UIColor.white
                cell.backgroundColor = FlatWhite()
                cell.themeButton.tintColor = FlatBlack()
                cell.mainLabel.textColor = FlatBlack()
            }
            return cell
            
        case "Download Settings":
            let cell:DownloadSettingsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "DownloadSettings") as! DownloadSettingsTableViewCell
            cell.downloadSettingsButton.addTarget(self, action: #selector(changeDownload), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.downloadSettingsButton, color: themeColor)
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.downloadSettingsButton.tintColor = FlatWhite()
                cell.mainLabel.textColor = FlatWhite()
            } else {
                cell.view.backgroundColor = UIColor.white
                cell.backgroundColor = FlatWhite()
                cell.downloadSettingsButton.tintColor = FlatBlack()
                cell.mainLabel.textColor = FlatBlack()
            }
            return cell

        case "Clear All Data":
            let cell:ClearAllDataTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ClearAll") as! ClearAllDataTableViewCell
            cell.clearData.setTitle("Clear All Data", for: .normal)
            Async.main {
                cell.clearData.setTitle("Clear All Data (" + getCacheSize() + ")", for: .normal)
            }
            cell.clearData.addTarget(self, action: #selector(clearAll(_:)), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.clearData, color: themeColor)
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.textLabel?.textColor = FlatWhite()
                cell.clearData.tintColor = FlatWhite()
            } else {
                cell.view.backgroundColor = UIColor.white
                cell.backgroundColor = FlatWhite()
                cell.clearData.tintColor = FlatBlack()
                cell.textLabel?.textColor = FlatBlack()
            }
            return cell
            
        case "Download Automatically":
            let cell:AutoDownloadTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "AutoDownload") as! AutoDownloadTableViewCell
            cell.pickerButton.addTarget(self, action: #selector(addAndShowPicker), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.pickerButton, color: themeColor)
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.textLabel?.textColor = FlatWhite()
                cell.pickerButton.tintColor = FlatWhite()
                cell.backgroundColor = FlatBlack()
                cell.mainLabel.textColor = FlatWhite()
            } else {
                cell.view.backgroundColor = UIColor.white
                cell.backgroundColor = FlatWhite()
                cell.pickerButton.tintColor = FlatBlack()
                cell.textLabel?.textColor = FlatWhite()
                cell.mainLabel.textColor = FlatBlack()
            }
            return cell
            
        case "Threads per Subreddit":
            let cell:NumberOfThreadsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ThreadsPerSubreddit") as! NumberOfThreadsTableViewCell
            cell.numberField.addTarget(self, action: #selector(changeThreadNumbers), for: UIControlEvents.editingChanged)
            cell.numberField.placeholder = "10"
            cell.numberField.tintColor = themeColor
            if Theme.getGeneralColor() == FlatBlack() {
                cell.textLabel?.textColor = FlatWhite()
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.mainLabel.textColor = FlatWhite()
            } else {
                cell.view.backgroundColor = UIColor.white
                cell.backgroundColor = FlatWhite()
                cell.textLabel?.textColor = FlatBlack()
                cell.mainLabel.textColor = FlatBlack()
            }
            return cell
            
            
        default:
            
            return UITableViewCell()
            
        }
        
        
        
    }
    
    
    func clearAll(_ sender: UIButton) {
        
        let alert = PMAlertController(title: "Clear All Data", color: Theme.getGeneralColor(), description: "This will delete ALL saved threads from ALL subreddits. Are you sure?", image: nil, style: .alert)
        alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, color: Theme.getGeneralColor()))
        alert.addAction(PMAlertAction(title: "Clear Data", style: .default, color: Theme.getGeneralColor(), action: { () in
            self.clearData(sender: sender)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func clearData(sender: UIButton) {
        //Delete all files/folders in the documents directory
        let fileManager = FileManager.default
        let documentsUrl =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    let filePathName = "\(documentPath)/\(fileName)"
                    try fileManager.removeItem(atPath: filePathName)
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
                sender.setTitle("Clear All Data (" + getCacheSize() + ")", for: .normal)
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
        
    }
    

    func changeThreadNumbers(textField: UITextField) {
        if textField.text != "" {
            let newNum = textField.text!
            self.defaults.set(newNum, forKey: "NumberOfThreads")
        }
    }
    
    
    func addAndShowPicker(sender: UITextField) {
        print("got it")
        ActionSheetMultipleStringPicker.show(withTitle: "Multiple String Picker", rows: [
            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
            ["AM", "PM"]
            ], initialSelection: [7, 0], doneBlock: {
                picker, indexes, values in
                var data = values as! [String]
                
                UserDefaults.standard.set([data[0],data[1]], forKey: "reminderDate")
                
                print("TIME: " + data[0] + " " + data[1])
                print("values = \(values)")
                print("indexes = \(indexes)")
                print("picker = \(picker)")
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    
} //End of Settings

