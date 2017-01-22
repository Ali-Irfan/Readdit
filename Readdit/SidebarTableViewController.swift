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
import Alamofire


var arrayOfSubreddits = UserDefaults.standard.object(forKey: "arrayOfSubreddits") as! [String]
var mainTextColor = UIColor()
var mainCellColor = UIColor()

class SidebarTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var logo: UILabel!

    var arrayOfIdentifiers: [String] = []
    var numberOfSubreddits = 0

    
    func getSubreddits() -> [String] {
        return arrayOfSubreddits
    }
    
    @IBOutlet weak var sidebarTable: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("View did load (front)")
        
        self.sidebarTable.dataSource = self
        self.sidebarTable.delegate = self
        sidebarTable.estimatedRowHeight = 250.0
        sidebarTable.rowHeight = UITableViewAutomaticDimension
        sidebarTable.allowsSelection = true
        


        
        
        arrayOfIdentifiers.append("subredditHeader")
        for _ in arrayOfSubreddits {
            arrayOfIdentifiers.append("subreddit")
            numberOfSubreddits = numberOfSubreddits + 1
        }
        
        arrayOfIdentifiers.append("settingsHeader")
        arrayOfIdentifiers.append("updateAll")
setupTheme()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupTheme()
        for cell in sidebarTable.visibleCells {
            cell.awakeFromNib()
        }
    }
    
    
    
    

    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        switch theme {
        case "green":
            
            let color = FlatGreenDark()
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
            
        case "default":
            
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
        print("Doing cell for row at \(identifier)")
        switch identifier {
        case "subredditHeader":
            let cell:SubredditHeaderTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subredditHeader") as! SubredditHeaderTableViewCell
            cell.addSubreddit.addTarget(self, action: #selector(addSubreddit), for: .touchUpInside)
            cell.backgroundColor = mainCellColor
            cell.addSubreddit.setTitleColor(mainTextColor, for: .normal)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case "subreddit":
            let cell:SubredditTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "subreddit") as! SubredditTableViewCell
            
            print(indexPath.row)
            print("arr \(arrayOfSubreddits.count)")
            cell.subredditTitle.setTitle(arrayOfSubreddits[indexPath.row-1], for: .normal)
            cell.deleteButton.addTarget(self, action: #selector(deleteSubreddit(_:)), for: .touchUpInside)
            cell.subredditTitle.addTarget(self, action: #selector(goToSubreddit(_:)), for: .touchUpInside)
            cell.subredditTitle.setTitleColor(mainTextColor, for: .normal)
            cell.backgroundColor = mainCellColor
            return cell
            
        case "settingsHeader":
            let cell:SettingsHeaderTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "settingsHeader") as! SettingsHeaderTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.settingsButton.addTarget(self, action: #selector(goToSubreddit(_:)), for: .touchUpInside)
            cell.backgroundColor = mainCellColor
            cell.settingsButton.setTitleColor(mainTextColor, for: .normal)
            
            return cell
        
        case "updateAll":
            let cell:UpdateAllTableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "updateAll") as! UpdateAllTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.updateAll.addTarget(self, action: #selector(updateAllSubreddits), for: .touchUpInside)
            cell.backgroundColor = mainCellColor
            cell.updateAll.setTitleColor(mainTextColor, for: .normal)
            return cell

        default:
            let cell:UITableViewCell = sidebarTable.dequeueReusableCell(withIdentifier: "settingsCell")! as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        }
    }
    
    
    
    func updateAllSubreddits() {
        
        let alert = UIAlertController(title: "Update all subreddits", message: "This may take a while. Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { [weak alert] (_) in
            for cell in self.sidebarTable.visibleCells {
                if let subredditCell = cell as? SubredditTableViewCell {
                    subredditCell.updateSubreddit()
                } else if let c = cell as? UpdateAllTableViewCell {
                    c.updateAll.isEnabled = false
                    c.stopButton.setImage(#imageLiteral(resourceName: "multiply"), for: .normal)
                    c.stopButton.addTarget(self, action: #selector(self.stopAllDownloads), for: .touchUpInside)
                }
            }
        }))
        

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func stopAllDownloads() {

        for cell in self.sidebarTable.visibleCells {
            if let s = cell as? SubredditTableViewCell {
                s.stopDownload()
            } else if let c = cell as? UpdateAllTableViewCell {
                c.stopButton.setImage(#imageLiteral(resourceName: "settings-4"), for: .normal)
                c.stopButton.removeTarget(self, action: #selector(self.stopAllDownloads), for: .touchUpInside)
                c.updateAll.isEnabled = true
            }
        }
        
    }
    
    func deleteSubreddit(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? SubredditTableViewCell {

            //Have to add in delete files too
            
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Remove Subreddit", message: "Are you sure you want to remove /r/\(cell.subredditTitle.currentTitle!)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak alert] (_) in
                print(cell.subredditTitle.currentTitle!)
                arrayOfSubreddits = arrayOfSubreddits.filter() { $0 != cell.subredditTitle.currentTitle! }
                UserDefaults.standard.set(arrayOfSubreddits, forKey: "arrayOfSubreddits")
                self.arrayOfIdentifiers.remove(at: self.arrayOfIdentifiers.count-3)
                do {
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let subredditPath = documentsPath.appendingPathComponent(cell.subredditTitle.currentTitle!)
                    try FileManager.default.removeItem(at: subredditPath!)
                } catch let error as NSError {
                    print("An error took place(DownloadThread): \(error)")
                }

                self.sidebarTable.reloadData()

            }))
            
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    func goToSubreddit(_ sender: UIButton) {
        if let currentCell = sender.superview?.superview as? SubredditTableViewCell{ //IF ITS A SUBREDDIT
            print("Here")
            let subreddit = (currentCell.subredditTitle.currentTitle!)
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ThreadNavigation") as! ThreadNavigationController
            let actualView = myVC.viewControllers.first as! ThreadListViewController
            actualView.subreddit = subreddit
            //present(myVC, animated: true, completion: nil)
            self.revealViewController().pushFrontViewController(myVC, animated: true)
        } else if sender.superview?.superview is SettingsHeaderTableViewCell {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as! UINavigationController
            self.revealViewController().pushFrontViewController(myVC, animated: true)
        }
    }
    
    
    func addSubreddit() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Subreddit", message: "Enter a subreddit name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "e.g. AskReddit"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let subredditToAdd = textField?.text?.stringByRemovingWhitespaces.capitalizingFirstLetter()
            if subredditToAdd != "" && !arrayOfSubreddits.contains(where: {$0.caseInsensitiveCompare(subredditToAdd!) == .orderedSame}) && !(subredditToAdd?.contains("+"))!{
                arrayOfSubreddits.append(subredditToAdd!)
                UserDefaults.standard.set(arrayOfSubreddits, forKey: "arrayOfSubreddits")
                self.arrayOfIdentifiers.insert("subreddit", at: self.arrayOfIdentifiers.count-2)
                self.sidebarTable.reloadData()
                Async.main{
                    // First figure out how many sections there are
                    let lastSectionIndex = self.sidebarTable!.numberOfSections - 1
                    
                    // Then grab the number of rows in the last section
                    let lastRowIndex = self.sidebarTable!.numberOfRows(inSection: lastSectionIndex) - 1
                    
                    // Now just construct the index path
                    
                    let pathToLastRow = NSIndexPath(row: lastRowIndex-1, section: lastSectionIndex)
                    
                    if let cell = self.sidebarTable.cellForRow(at: pathToLastRow as IndexPath) as? SubredditTableViewCell {
                        cell.updateSubreddit()
                    }
                }
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

}



extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
        var stringByRemovingWhitespaces: String {
            return components(separatedBy: .whitespaces).joined(separator: "")
        }
    
    func convertHtmlSymbols() throws -> String? {
        guard let data = data(using: .utf8) else { return nil }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}
