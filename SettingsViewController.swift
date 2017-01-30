import UIKit
import SwiftyJSON
import ChameleonFramework
import Async
import PMAlertController
import XLActionController

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var themeColor:UIColor = UIColor.blue
    let arrayOfSettings = ["Text Size", "Download Settings", "Download Automatically", "Threads per Subreddit", "Theme", "Hide NSFW Content", "Report A Bug", "Clear All Data"]
    
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
        //Temporarily stop logging visual errors
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
            settingsTable.backgroundColor = FlatBlackDark()
            self.view.backgroundColor = FlatBlackDark()
                case "default":
            themeColor = FlatWhite()
            Theme.setNavbarTheme(navigationController: n, color: themeColor)
            Utils.addMenuButton(color: UIColor.black, navigationItem: navigationItem, revealViewController: revealViewController())
            default:
            print("Idk")
        }
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
        if defaults.object(forKey: "fontSize") != nil {} else {        defaults.set("regular", forKey: "fontSize")}
        if defaults.object(forKey: "theme") != nil {} else {           defaults.set("default", forKey: "theme")}
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
    
    
    
    
    func changeDownloadTimes(_ sender: UIButton!) {
        
        let optionMenu = SkypeActionController()
        
        let manual = Action("Manual", style: .default, handler: { action in
            sender.setTitle("Manually Download", for: .normal)
            self.defaults.set(0, forKey: "downloadTime")
        })
        
        let t2hr = Action("Every 2 hours", style: .default, handler: { action in
            sender.setTitle("1 hour", for: .normal)
            self.defaults.set(1*60*60, forKey: "downloadTime")
        })
        
        let t6hr = Action("Every 6 hours", style: .default, handler: { action in
            sender.setTitle("6 hours", for: .normal)
            self.defaults.set(6*60*60, forKey: "downloadTime")
        })
        
        let t12hr = Action("Every 12 hours", style: .default, handler: { action in
            sender.setTitle("12 hours", for: .normal)
            self.defaults.set(12*60*60, forKey: "downloadTime")
        })
        
        let t24hr = Action("Every 24 hours", style: .default, handler: { action in
            sender.setTitle("24 hours", for: .normal)
            self.defaults.set(24*60*60, forKey: "downloadTime")
        })
        
        let t48hr = Action("Every 48 hours", style: .default, handler: { action in
            sender.setTitle("48 hours", for: .normal)
            self.defaults.set(48*60*60, forKey: "downloadTime")
        })
        
        let cancelAction = Action("Cancel", style: .cancel, handler: { action in
            print("Cancelled")
        })

        optionMenu.addAction(manual)
        optionMenu.addAction(t2hr)
        optionMenu.addAction(t6hr)
        optionMenu.addAction(t12hr)
        optionMenu.addAction(t24hr)
        optionMenu.addAction(t48hr)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func changeTheme(_ sender: UIButton) {
        //let optionMenu = UIAlertController(title: nil, message: "Choose Theme", preferredStyle: .actionSheet)
        let optionMenu = SkypeActionController()
        // 2
        let defaultTheme = Action("default", style: .default, handler: { action in
            sender.setTitle("default", for: .normal)
            self.defaults.set("default", forKey: "theme")
            
            self.defaults.set(FlatWhite().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatWhite().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatWhite().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let mint = Action("mint", style: .default, handler: { action in
            sender.setTitle("mint", for: .normal)
            self.defaults.set("mint", forKey: "theme")
            self.defaults.set(FlatMint().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatMint().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatMint().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let purple = Action("purple", style: .default, handler: { action in
            sender.setTitle("purple", for: .normal)
            self.defaults.set("purple", forKey: "theme")
            self.defaults.set(FlatPurple().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatPurple().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatPurple().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let lime = Action("lime", style: .default, handler: { action in
            sender.setTitle("lime", for: .normal)
            self.defaults.set("lime", forKey: "theme")
            self.defaults.set(FlatLime().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatLime().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatLime().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        let magenta = Action("magenta", style: .default, handler: { action in
            sender.setTitle("magenta", for: .normal)
            self.defaults.set(FlatMagenta().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatMagenta().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatMagenta().getRGBAComponents()?.green, forKey: "themeGreen")
            self.defaults.set("magenta", forKey: "theme")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        
        let blue = Action("blue", style: .default, handler: { action in
            sender.setTitle("blue", for: .normal)
            self.defaults.set("blue", forKey: "theme")
            self.defaults.set(FlatSkyBlue().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatSkyBlue().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatSkyBlue().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
        })
        
        //
        let red = Action("red", style: .default, handler: { action in
            sender.setTitle("red", for: .normal)
            self.defaults.set("red", forKey: "theme")
            self.defaults.set(FlatRed().getRGBAComponents()?.red, forKey: "themeRed")
            self.defaults.set(FlatRed().getRGBAComponents()?.blue, forKey: "themeBlue")
            self.defaults.set(FlatRed().getRGBAComponents()?.green, forKey: "themeGreen")
            self.setupTheme()
            self.settingsTable.reloadData()
            
            
        })
        
        let dark = Action("dark", style: .default, handler: { action in
            sender.setTitle("dark", for: .normal)
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
                
            }
            return cell
            
        case "Hide NSFW Content":
            let cell:HideNSFWPostsTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "HideNSFW") as! HideNSFWPostsTableViewCell
            if let key = UserDefaults.standard.object(forKey: "hideNSFW") as? Bool { //Key exists
                cell.nsfwSwitch.isOn = key
            } else { //Default is not hiding
                cell.nsfwSwitch.isOn = false
            }
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.textLabel?.textColor = FlatWhite()
                
            }
            return cell
            
        case "Report A Bug":
            let cell:ReportABugTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "ReportBug") as! ReportABugTableViewCell
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.backgroundColor = FlatBlack()
                cell.textLabel?.textColor = FlatWhite()
                
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
                
                
            }
            return cell
            
        case "Download Automatically":
            let cell:AutoDownloadTableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "AutoDownload") as! AutoDownloadTableViewCell
            cell.pickerButton.addTarget(self, action: #selector(changeDownloadTimes), for: .touchUpInside)
            Theme.setButtonColor(button:  cell.pickerButton, color: themeColor)
            if Theme.getGeneralColor() == FlatBlack() {
                cell.view.backgroundColor = FlatBlackDark()
                cell.textLabel?.textColor = FlatWhite()
                cell.pickerButton.tintColor = FlatWhite()
                cell.backgroundColor = FlatBlack()
                
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
    
    
} //End of Settings



extension UIColor
{
    /**
     Returns the components that make up the color in the RGB color space as a tuple.
     
     - returns: The RGB components of the color or `nil` if the color could not be converted to RGBA color space.
     */
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?
    {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            return (red, green, blue, alpha)
        }
        else
        {
            return nil
        }
    }
    
    /**
     Returns the components that make up the color in the HSB color space as a tuple.
     
     - returns: The HSB components of the color or `nil` if the color could not be converted to HSBA color space.
     */
    func getHSBAComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)?
    {
        var (hue, saturation, brightness, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        {
            return (hue, saturation, brightness, alpha)
        }
        else
        {
            return nil
        }
    }
    
    /**
     Returns the grayscale components of the color as a tuple.
     
     - returns: The grayscale components or `nil` if the color could not be converted to grayscale color space.
     */
    func getGrayscaleComponents() -> (white: CGFloat, alpha: CGFloat)?
    {
        var (white, alpha) = (CGFloat(0.0), CGFloat(0.0))
        if self.getWhite(&white, alpha: &alpha)
        {
            return (white, alpha)
        }
        else
        {
            return nil
        }
    }
}

