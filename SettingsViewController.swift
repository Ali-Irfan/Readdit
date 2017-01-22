import UIKit
import SwiftyJSON
import ChameleonFramework
import Async

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var themeColor:UIColor = UIColor.blue
    let arrayOfSettings = ["Text Size", "Download Settings", "Download Automatically", "Threads per Subreddit", "Theme", "Hide NSFW Content", "Report A Bug", "Clear All Data"]
    
    @IBOutlet weak var settingsTable: UITableView!
    var totalSize = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Downloader.initializeConfig()
        setDefaults()
        setupTheme()
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 250
            
            view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            let revealController = self.revealViewController() as? RevealViewController
            
            revealController?.settingsController = self
            
        }
        
 
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        settingsTable.dataSource = self
        settingsTable.delegate = self
        settingsTable.backgroundColor = FlatWhite()
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
            
        case "purple":
            themeColor = FlatPurple()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
        case "magenta":
            themeColor = FlatMagenta()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
        case "lime":
            themeColor = FlatLime()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
        case "blue":
            themeColor = FlatSkyBlue()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())            
            
        case "red":
            themeColor = FlatRed()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
        case "dark":
            themeColor = FlatBlack()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
        case "default":
            themeColor = FlatWhite()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.black, navigationItem: navigationItem, revealViewController: revealViewController())
        
        default:
            print("Idk")
        }
    }

    
    
    
    func setDefaults() {
        if let key = defaults.string(forKey: "network") {
            //Do nothing because it already exists
        } else {
            //Set a default value because it was never set before
            defaults.set("wifi", forKey: "network")
        }
        
        let obj: [String] = []
        defaults.set(obj, forKey: "inProgress")
        
        
        if let key = defaults.object(forKey: "arrayOfSubreddits") {
            
        } else {
            let defaultSubreddits: [String] = ["AskReddit", "AskScience", "IAmA", "News", "ExplainLikeImFive", "Jokes", "NSFW"]
            defaults.set(defaultSubreddits, forKey: "arrayOfSubreddits")
        }
        
        if let key = defaults.object(forKey: "downloadTime") {
            
        } else {
            defaults.set(0, forKey: "downloadTime")
        }
        
        if let key = defaults.object(forKey: "fontSize") {
            
        } else {
            defaults.set("regular", forKey: "fontSize")
        }
        
        if let key = defaults.object(forKey: "theme") {
            
        } else {
            defaults.set("default", forKey: "theme")
        }
        
    }
    
    func changeDownload(_ sender: UIButton!) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let dataOnly = UIAlertAction(title: "Data Only", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Data Only", for: .normal)
            print("Data Only")
            self.defaults.set("data", forKey: "network")
            
        })
        let wifiOnly = UIAlertAction(title: "Wi-Fi Only", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Wi-Fi Only", for: .normal)
            print("Wi-Fi Only")
            self.defaults.set("wifi", forKey: "network")
        })
        
        //
        let both = UIAlertAction(title: "Both", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Data + WiFi", for: .normal)
            self.defaults.set("both", forKey: "network")
            print("Both")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        optionMenu.addAction(dataOnly)
        optionMenu.addAction(wifiOnly)
        optionMenu.addAction(both)
        optionMenu.addAction(cancelAction)
        
        // 5
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func changeTextSize(_ sender: UIButton!) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let large = UIAlertAction(title: "Large", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Clicked large")
            sender.setTitle("Large", for: .normal)
            self.defaults.set("large", forKey: "fontSize")
        })
        
        //
        let regular = UIAlertAction(title: "Regular", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Regular", for: .normal)
            self.defaults.set("regular", forKey: "fontSize")
        })
        
        let small = UIAlertAction(title: "Small", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Small", for: .normal)
            self.defaults.set("small", forKey: "fontSize")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        
        // 4
        optionMenu.addAction(large)
        optionMenu.addAction(regular)
        optionMenu.addAction(small)
        optionMenu.addAction(cancelAction)
        
        // 5
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    func changeDownloadTimes(_ sender: UIButton!) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        // 2
        let manual = UIAlertAction(title: "Manual", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Manually Download", for: .normal)
            self.defaults.set(0, forKey: "downloadTime")
            
        })
        
        let t2hr = UIAlertAction(title: "Every 2 hours", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("1 hour", for: .normal)
            self.defaults.set(1*60*60, forKey: "downloadTime")
            
        })
        let t6hr = UIAlertAction(title: "Every 6 hours", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("6 hours", for: .normal)
            self.defaults.set(6*60*60, forKey: "downloadTime")
        })
        
        //
        let t12hr = UIAlertAction(title: "Every 12 hours", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("12 hours", for: .normal)
            self.defaults.set(12*60*60, forKey: "downloadTime")
        })
        
        let t24hr = UIAlertAction(title: "Every 24 hours", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("24 hours", for: .normal)
            self.defaults.set(24*60*60, forKey: "downloadTime")
        })
        
        let t48hr = UIAlertAction(title: "Every 48 hours", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("48 hours", for: .normal)
            self.defaults.set(48*60*60, forKey: "downloadTime")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        
        // 4
        optionMenu.addAction(manual)
        optionMenu.addAction(t2hr)
        optionMenu.addAction(t6hr)
        optionMenu.addAction(t12hr)
        optionMenu.addAction(t24hr)
        optionMenu.addAction(t48hr)
        optionMenu.addAction(cancelAction)
        
        // 5
        
        present(optionMenu, animated: true, completion: nil)
        
    }

    func changeTheme(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Theme", preferredStyle: .actionSheet)
        
        // 2
        let defaultTheme = UIAlertAction(title: "default", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("default", for: .normal)
            self.defaults.set("default", forKey: "theme")
            self.setupTheme()
            self.settingsTable.reloadData()

        })
        
        let mint = UIAlertAction(title: "mint", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("mint", for: .normal)
            self.defaults.set("mint", forKey: "theme")
             self.setupTheme()
            self.settingsTable.reloadData()

        })
        
        let purple = UIAlertAction(title: "purple", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("purple", for: .normal)
            self.defaults.set("purple", forKey: "theme")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let lime = UIAlertAction(title: "lime", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("lime", for: .normal)
            self.defaults.set("lime", forKey: "theme")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let magenta = UIAlertAction(title: "magenta", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("magenta", for: .normal)
            self.defaults.set("magenta", forKey: "theme")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        
        let blue = UIAlertAction(title: "blue", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("blue", for: .normal)
            self.defaults.set("blue", forKey: "theme")
             self.setupTheme()
            self.settingsTable.reloadData()

        })
        
        //
        let red = UIAlertAction(title: "red", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("red", for: .normal)
            self.defaults.set("red", forKey: "theme")
             self.setupTheme()
            self.settingsTable.reloadData()
   

        })
        
        let dark = UIAlertAction(title: "dark", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("dark", for: .normal)
            self.defaults.set("dark", forKey: "theme")
             self.setupTheme()
            self.settingsTable.reloadData()

        })
        

        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        
        // 4
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
    
    
    func changeSortType(_ sender: UIButton!) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let best = UIAlertAction(title: "Best", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Best", for: .normal)
            self.defaults.set("best", forKey: "sort")
        })
        let top = UIAlertAction(title: "Top", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Top", for: .normal)
            self.defaults.set("top", forKey: "sort")
        })
        
        //
        let new = UIAlertAction(title: "New", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("New", for: .normal)
            self.defaults.set("new", forKey: "sort")
        })
        
        let controversial = UIAlertAction(title: "Controversial", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Controversial", for: .normal)
            self.defaults.set("controversial", forKey: "sort")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        
        // 4
        optionMenu.addAction(best)
        optionMenu.addAction(top)
        optionMenu.addAction(new)
        optionMenu.addAction(controversial)
        optionMenu.addAction(cancelAction)
        
        // 5
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    // Do any additional setup after loading the view.
    
    
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
        
        //settingsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        switch setting {
        case "Text Size":
            let cell:TextSizeTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "TextSize") as! TextSizeTableViewCell
            cell.textSizeButton.addTarget(self, action: #selector(changeTextSize), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.textSizeButton, color: themeColor)
            return cell
        case "Theme":
            let cell:ThemeTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "Theme") as! ThemeTableViewCell
            cell.themeButton.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.themeButton, color: themeColor)
            return cell
            
        case "Download Settings":
            let cell:DownloadSettingsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "DownloadSettings") as! DownloadSettingsTableViewCell
            cell.downloadSettingsButton.addTarget(self, action: #selector(changeDownload), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.downloadSettingsButton, color: themeColor)
            return cell
            
        case "Hide NSFW Content":
            let cell:HideNSFWPostsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "HideNSFW") as! HideNSFWPostsTableViewCell
            if let key = UserDefaults.standard.object(forKey: "hideNSFW") as? Bool { //Key exists
                cell.nsfwSwitch.isOn = key
            } else { //Default is not hiding
                cell.nsfwSwitch.isOn = false
            }
            return cell
            
        case "Report A Bug":
            let cell:ReportABugTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ReportBug") as! ReportABugTableViewCell
            
            return cell
            
        case "Clear All Data":
            let cell:ClearAllDataTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ClearAll") as! ClearAllDataTableViewCell
            cell.clearData.setTitle("Clear All Data", for: .normal)
            Async.main {
            cell.clearData.setTitle("Clear All Data (" + getCacheSize() + ")", for: .normal)
            }
            cell.clearData.addTarget(self, action: #selector(clearAll(_:)), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.clearData, color: themeColor)
            return cell
            
        case "Download Automatically":
            let cell:AutoDownloadTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "AutoDownload") as! AutoDownloadTableViewCell
            cell.pickerButton.addTarget(self, action: #selector(changeDownloadTimes), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.pickerButton, color: themeColor)
            return cell
            
        case "Threads per Subreddit":
            let cell:NumberOfThreadsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ThreadsPerSubreddit") as! NumberOfThreadsTableViewCell
            cell.numberField.addTarget(self, action: #selector(changeThreadNumbers), for: UIControlEvents.editingChanged)
            cell.numberField.placeholder = "10"
            cell.numberField.tintColor = themeColor
            return cell
            
            
        default:
         
            return UITableViewCell()
            
        }
        
        
        
    }
    
    
    func clearAll(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Clear All Data", message: "This will delete ALL saved threads from ALL subreddits. Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Clear Data", style: .destructive, handler: { [weak alert] (_) in
            self.clearData(sender: sender)
        }))
        
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    


    func clearData(sender: UIButton) {
        let fileManager = FileManager.default
        //let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsUrl =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    
                    //if (fileName.hasSuffix(".png"))
                    //{
                    let filePathName = "\(documentPath)/\(fileName)"
                    try fileManager.removeItem(atPath: filePathName)
                    //}
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
                sender.setTitle("Clear All Data (" + getCacheSize() + ")", for: .normal)
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    
}


    
    func showDownloadPicker() {
        
    }
    
    func changeThreadNumbers(textField: UITextField) {
        if textField.text != "" {
            let newNum = textField.text!
            self.defaults.set(newNum, forKey: "NumberOfThreads")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}

