
import UIKit
import SwiftyJSON
import Async
import EZLoadingActivity
import ChameleonFramework

class ThreadListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var overlay : UIView? // This should be a class variable
    
    var generalColor:UIColor = UIColor.black
    var arrayOfThreads: [ThreadData] = []
    var subreddit = ""
    var isDownloading:Bool = false
    let myNotification = Notification.Name(rawValue:"MyNotification")
    
    
    @IBOutlet weak var threadTable: UITableView!
    var jsonRaw = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.darkGray
        overlay!.alpha = 0.8
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        
        overlay?.addSubview(activityView)
        view.addSubview(overlay!)
        
        checkCurrentDownloads()
        
        navigationItem.title = "/r/" + subreddit

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationItem.hidesBackButton = true
        
        if revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().rearViewController.revealViewController().panGestureRecognizer())
            
            
            revealViewController().rightViewRevealWidth = 150
            revealViewController().rearViewRevealWidth = 250
        }
        
//        let btn1 = UIButton(type: .custom)
//        btn1.setImage(#imageLiteral(resourceName: "menu-2"), for: .normal)
//        btn1.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
//        btn1.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//        let item1 = UIBarButtonItem(customView: btn1)
//        navigationItem.leftBarButtonItem = item1
        
        threadTable.delegate = self
        threadTable.dataSource = self
        threadTable.rowHeight = UITableViewAutomaticDimension
        threadTable.estimatedRowHeight = 140
        navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        threadTable.backgroundColor = FlatWhite()//General.hexStringToUIColor(hex: "#dadada")
        setupTheme()

        Async.main {
        self.displayThreads()
        }
        
    }
    
    

    
    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        let n = navigationController!
        switch theme {
        case "green":
            Theme.setNavbarColor(navigationController: n, color: FlatGreen())
            n.navigationBar.barStyle = .black
            self.setStatusBarStyle(UIStatusBarStyleContrast)
            self.navigationController?.hidesNavigationBarHairline = true
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())

            generalColor = FlatGreenDark()

        case "blue":
            Theme.setNavbarColor(navigationController: n, color: FlatSkyBlue())
            n.navigationBar.barStyle = .black
            navigationController?.setStatusBarStyle(UIStatusBarStyleContrast)
            self.setStatusBarStyle(UIStatusBarStyleContrast)
            self.navigationController?.hidesNavigationBarHairline = true
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())

            generalColor = FlatSkyBlue()

            
        case "red":
            Theme.setNavbarColor(navigationController: n, color: FlatRed())
            n.navigationBar.barStyle = .black
            navigationController?.setStatusBarStyle(UIStatusBarStyleContrast)
            self.navigationController?.hidesNavigationBarHairline = true
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())

            generalColor = FlatRed()
            

        case "dark":
            Theme.setNavbarColor(navigationController: n, color: FlatBlack())
            n.navigationBar.barStyle = .black

            navigationController?.setStatusBarStyle(UIStatusBarStyleContrast)
            self.navigationController?.hidesNavigationBarHairline = true
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())

            generalColor = FlatBlack()

        case "default":
            Theme.setNavbarColor(navigationController: n, color: FlatWhite())
            n.navigationBar.barStyle = .default
            Utils.addMenuButton(color: UIColor.black, navigationItem: navigationItem, revealViewController: revealViewController())
            navigationController?.setStatusBarStyle(UIStatusBarStyleContrast)
            self.navigationController?.hidesNavigationBarHairline = true
            generalColor = FlatBlackDark()

        default:
            print("Idk")
        }
    }
    
    func catchNotification(notification:Notification) -> Void {
        checkCurrentDownloads()
    }
    
    func checkCurrentDownloads() {
        print("GOT IT")
        let downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
        print(downloadsInProgress)
        print("This subreddit: " + subreddit)
        print("Checking to see if \(subreddit) is in  \(downloadsInProgress)")
        
        
        if downloadsInProgress.contains(subreddit) {
            overlay?.isHidden = false
            isDownloading = true
        } else {
            overlay?.isHidden = true
            isDownloading = false
        }
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("View appeared")
        self.navigationItem.hidesBackButton = true
        revealViewController().rearViewRevealWidth = 250
        view.addGestureRecognizer(self.revealViewController().rearViewController.revealViewController().panGestureRecognizer())
        checkCurrentDownloads()
    }
    
    func updateThreads() {
        
        if Utils.hasAppropriateConnection() {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            Async.background {
                Downloader.downloadJSON(subreddit: self.subreddit)
                
                self.jsonRaw = Downloader.getJSON(subreddit: self.subreddit, sortType: "Top")
                self.arrayOfThreads.removeAll()
                if (self.jsonRaw != "Error") {
                    if let data = self.jsonRaw.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        let threads = json["data"]["children"]
                        // print(json)
                        for (_, thread):(String, JSON) in threads {
                            let thisThread = ThreadData()
                            thisThread.title = thread["data"]["title"].string!
                            thisThread.author = thread["data"]["author"].string!
                            thisThread.upvotes = thread["data"]["ups"].int!
                            thisThread.commentCount = thread["data"]["num_comments"].int!
                            thisThread.id = thread["data"]["id"].string!
                            thisThread.nsfw = Bool(thread["data"]["over_18"].boolValue)
                            thisThread.permalink = thread["data"]["permalink"].string!
                            thisThread.utcCreated = thread["data"]["created_utc"].double!
                            
                            if let key = UserDefaults.standard.object(forKey: "hideNSFW") as? Bool { //Key exists
                                
                                if !key {
                                    self.arrayOfThreads.append(thisThread)
                                }
                                
                            } else { //Default is not hiding
                                self.arrayOfThreads.append(thisThread)
                            }
                        }
                        for thread in self.arrayOfThreads {
                            Downloader.downloadThreadJSON(subreddit: self.subreddit, threadURL: thread.permalink, threadID: thread.id)
                        }
                        self.threadTable.reloadData()
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    }
                }
            } //END ASYNC
        } else {
            Utils.displayTheAlert(targetVC: (UIApplication.shared.keyWindow?.rootViewController)!, title: "Error", message: "You need a valid/appropriate internet connection to download threads.")
        }
    }
    
    
    
    
    func displayThreads() {
        jsonRaw = Downloader.getJSON(subreddit: subreddit, sortType: "Top")
        if (jsonRaw != "Error") {
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let threads = json["data"]["children"]
                // print(json)
                for (_, thread):(String, JSON) in threads {
                    let thisThread = ThreadData()
                    thisThread.title = thread["data"]["title"].string!
                    thisThread.author = thread["data"]["author"].string!
                    thisThread.upvotes = thread["data"]["ups"].int!
                    thisThread.commentCount = thread["data"]["num_comments"].int!
                    thisThread.id = thread["data"]["id"].string!
                    thisThread.nsfw = Bool(thread["data"]["over_18"].boolValue)
                    thisThread.permalink = thread["data"]["permalink"].string!
                    thisThread.utcCreated = thread["data"]["created_utc"].double!
                    
                    if let key = UserDefaults.standard.object(forKey: "hideNSFW") as? Bool { //Key exists
                        
                        if !key {
                            arrayOfThreads.append(thisThread)
                        }
                        
                    } else { //Default is not hiding
                        arrayOfThreads.append(thisThread)
                    }
                    
                }
            }
        }
        if !isDownloading {
        overlay?.isHidden = true
        }
        threadTable.reloadData()



    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrayOfThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:THREADTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mycell2") as! THREADTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        var size:CGFloat = 0.0
        print("Current default: \(UserDefaults.standard.string(forKey: "fontSize"))")
        if UserDefaults.standard.string(forKey: "fontSize") == "small" {
            size = 10
            cell.mainText.font = UIFont(name: cell.mainText.font.fontName, size: 15)
            cell.authorLabel.font = UIFont(name: cell.authorLabel.font.fontName, size: 10)
            cell.hoursText.font = UIFont(name: cell.hoursText.font.fontName, size: 10)
        } else if UserDefaults.standard.string(forKey: "fontSize") == "regular" {
            size = 12
            cell.mainText.font = UIFont(name: cell.mainText.font.fontName, size: 17)
            cell.hoursText.font = UIFont(name: cell.hoursText.font.fontName, size: 12)
            cell.authorLabel.font = UIFont(name: cell.authorLabel.font.fontName, size: 12)

        } else if UserDefaults.standard.string(forKey: "fontSize") == "large" {
            size = 14
            cell.mainText.font = UIFont(name: cell.mainText.font.fontName, size: 19)
            cell.hoursText.font = UIFont(name: cell.hoursText.font.fontName, size: 14)
            cell.authorLabel.font = UIFont(name: cell.authorLabel.font.fontName, size: 14)
        }
        
        cell.topViewBar.backgroundColor = FlatWhite()//General.hexStringToUIColor(hex: "#dadada")
        cell.mainText?.text = arrayOfThreads[indexPath.row].title
        cell.authorLabel?.text = "/u/" + arrayOfThreads[indexPath.row].author
        let dateText = Utils.timeAgoSince(Date(timeIntervalSince1970: Double(arrayOfThreads[indexPath.row].utcCreated)))
        cell.hoursText?.text = " • " + String(arrayOfThreads[indexPath.row].upvotes)
        
        let firstWord   = dateText
        let secondWord = String(arrayOfThreads[indexPath.row].upvotes)
        let attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size), NSForegroundColorAttributeName: generalColor] as [String : Any]
        let attributedText = NSMutableAttributedString(string:firstWord)
        attributedText.append(NSMutableAttributedString(string: " • "))
        attributedText.append(NSAttributedString(string: secondWord, attributes: attrs))
        cell.hoursText?.attributedText = attributedText
        
        cell.textLabel?.numberOfLines=0;
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! THREADTableViewCell
        
        var threadURL = ""
        var threadID = ""
        
        if (jsonRaw != "Error") {
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let threads = json["data"]["children"]
                for (_, thread):(String, JSON) in threads {
                    let title = thread["data"]["title"]
                    if title.string! == currentCell.mainText?.text {
                        threadURL = ( thread["data"]["permalink"].string! )
                        threadID = thread["data"]["id"].string!
                    }
                }
            }
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ThreadView") as! ThreadViewController
            myVC.threadURL = "https://reddit.com" + threadURL
            myVC.threadID = threadID
            myVC.subreddit = subreddit
            //present(myVC, animated: true, completion: nil)

            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    func sendAlert(TITLE:String, MESSAGE:String, BUTTON:String) {
        let alert = UIAlertController(title: TITLE, message: MESSAGE, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: BUTTON, style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

