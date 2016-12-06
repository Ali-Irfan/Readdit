import UIKit
import SwiftyJSON

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    let arrayOfSettings = ["Text Size", "Dark Mode", "Download Settings", "Hide NSFW Posts", "Report A Bug", "Clear All Data"]
    
    @IBOutlet weak var settingsTable: UITableView!
    var totalSize = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        settingsTable.dataSource = self
        settingsTable.delegate = self
        settingsTable.estimatedRowHeight = 250.0
        settingsTable.rowHeight = UITableViewAutomaticDimension
        settingsTable.allowsSelection = false
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            for path in directoryContents {
                totalSize = totalSize + General.getFileSize(path: String(describing: path))
            }
            
            print(totalSize)

        } catch let error as NSError {
            print(error.localizedDescription)
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
            
        })
        let wifiOnly = UIAlertAction(title: "Wi-Fi Only", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Wi-Fi Only", for: .normal)
            print("Wi-Fi Only")
        })
        
        //
        let both = UIAlertAction(title: "Both", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("Data + WiFi", for: .normal)
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
            })
            let large = UIAlertAction(title: "Large", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Large", for: .normal)
            })
            
            //
            let regular = UIAlertAction(title: "Regular", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Regular", for: .normal)
            })
            
            let small = UIAlertAction(title: "Small", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                sender.setTitle("Small", for: .normal)
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

        default:
            let cell:UITableViewCell = settingsTable.dequeueReusableCell(withIdentifier: "settingsCell")! as UITableViewCell
            return cell

        }
        
        
        
    }
    
    
    

    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    


    
}
