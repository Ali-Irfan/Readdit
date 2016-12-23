import UIKit
import SwiftyJSON

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    let defaults = UserDefaults.standard
    
    let arrayOfSettings = ["Text Size", "Dark Mode", "Download Settings", "Hide NSFW Posts", "Default Sorting Type", "Report A Bug", "Clear All Data", "Threads per Subreddit"]
    
    @IBOutlet weak var settingsTable: UITableView!
    var totalSize = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 300
            
            view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            let revealController = self.revealViewController() as? RevealViewController
            
            revealController?.settingsController = self

        }
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        settingsTable.dataSource = self
        settingsTable.delegate = self
        settingsTable.estimatedRowHeight = 250.0
        settingsTable.rowHeight = UITableViewAutomaticDimension
        settingsTable.allowsSelection = false
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
            
            // 2
            let xlarge = UIAlertAction(title: "Extra Large", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Extra Large", for: .normal)
                self.defaults.set("extra large", forKey: "textSize")
                
            })
            let large = UIAlertAction(title: "Large", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Large", for: .normal)
                self.defaults.set("large", forKey: "textSize")
            })
            
            //
            let regular = UIAlertAction(title: "Regular", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Regular", for: .normal)
                self.defaults.set("regular", forKey: "textSize")
            })
            
            let small = UIAlertAction(title: "Small", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Small", for: .normal)
                self.defaults.set("small", forKey: "textSize")
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
        
        
        
        // 4
        optionMenu.addAction(xlarge)
        optionMenu.addAction(large)
        optionMenu.addAction(regular)
        optionMenu.addAction(small)
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

        settingsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        switch setting {
        case "Text Size":
            let cell:TextSizeTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "TextSize") as! TextSizeTableViewCell
            cell.textSizeButton.addTarget(self, action: #selector(changeTextSize), for: .touchUpInside)
            return cell
        case "Dark Mode":
            let cell:DarkModeTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "DarkMode") as! DarkModeTableViewCell
            return cell

        case "Download Settings":
            let cell:DownloadSettingsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "DownloadSettings") as! DownloadSettingsTableViewCell
            cell.downloadSettingsButton.addTarget(self, action: #selector(changeDownload), for: .touchUpInside)
            return cell

        case "Hide NSFW Posts":
            let cell:HideNSFWPostsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "HideNSFW") as! HideNSFWPostsTableViewCell
            return cell

        case "Report A Bug":
            let cell:ReportABugTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ReportBug") as! ReportABugTableViewCell
            return cell

        case "Clear All Data":
            let cell:ClearAllDataTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ClearAll") as! ClearAllDataTableViewCell
            return cell
            
        case "Default Sorting Type":
            let cell:DefaultSortingTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "defaultSort") as! DefaultSortingTableViewCell
            cell.sortingButton.addTarget(self, action: #selector(changeSortType), for: .touchUpInside)
            return cell
            
        case "Threads per Subreddit":
            let cell:NumberOfThreadsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ThreadsPerSubreddit") as! NumberOfThreadsTableViewCell
            cell.numberField.addTarget(self, action: #selector(changeThreadNumbers), for: UIControlEvents.editingChanged)
            return cell


        default:
            let cell:UITableViewCell = settingsTable.dequeueReusableCell(withIdentifier:"settingsCell")! as UITableViewCell
            return cell

        }
        
        
        
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

