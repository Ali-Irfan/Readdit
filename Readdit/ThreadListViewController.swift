
import UIKit
import SwiftyJSON
import Async
import ChameleonFramework
import FontAwesomeKit

class ThreadListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var overlay : UIView?
    var emptyOverlay : UIView!
    var deletedOverlay: UIView!
    
    var generalColor:UIColor = UIColor.black
    var arrayOfThreads: [ThreadData] = []
    var subreddit = ""
    var isDownloading:Bool = false
     //Placeholder name
    
    
    @IBOutlet weak var threadTable: UITableView!
    var jsonRaw = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(forName:updateViewNotification, object:nil, queue:nil, using:catchNotification)
        
        //Adding an overlay for async loading
        deletedOverlay = UIView(frame: view.frame)
        deletedOverlay.backgroundColor = Theme.getGeneralColor()
        deletedOverlay.isHidden = true
        deletedOverlay.alpha = 1.0
        view.addSubview(deletedOverlay)

        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.darkGray
        overlay!.alpha = 0.8
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        overlay?.addSubview(activityView)
        view.addSubview(overlay!)
        
        emptyOverlay = UIView(frame: threadTable.frame)
        if Theme.getGeneralColor() == FlatBlack() {
            emptyOverlay.backgroundColor = FlatBlack()
            generalColor = UIColor.white
        } else {
            emptyOverlay.backgroundColor = FlatWhite()
        }
        let oopsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-100, height: 200))
        oopsLabel.center = self.view.center
        oopsLabel.textAlignment = .center
        oopsLabel.center.y = view.center.y - 140
        oopsLabel.center.x = view.center.x
        oopsLabel.numberOfLines = 0
        
        let oopsLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-50, height: 100))
        oopsLabel2.center = self.view.center
        oopsLabel2.textAlignment = .center
        oopsLabel2.center.y = view.center.y + 100
        oopsLabel2.center.x = view.center.x
        oopsLabel2.numberOfLines = 0
        
        let oopsButton = UIButton()
        let oopsImage = #imageLiteral(resourceName: "cloud-big").maskWithColor(color: Theme.getGeneralColor())
        oopsButton.setImage(oopsImage, for: .normal)
        oopsButton.frame = CGRect(x: 0, y: 0, width: 200, height: 133)
        oopsButton.addTarget(self, action: #selector(updateThisSubreddit), for: .touchUpInside)
        oopsButton.center = view.center
        emptyOverlay.addSubview(oopsButton)
        

        emptyOverlay.isHidden = true
        oopsLabel.text = "This subreddit hasn't been downloaded yet."
        oopsLabel2.text = "Click the button above to download!"
        oopsLabel2.textColor = FlatBlack()
        oopsLabel.textColor = Theme.getGeneralColor()
        emptyOverlay.addSubview(oopsLabel)
        emptyOverlay.addSubview(oopsLabel2)
        view.addSubview(emptyOverlay)
        
        checkCurrentDownloads()
        navigationItem.title = "/r/" + subreddit
        
        //Remove the title from the back button of the NavigationController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
        
        if revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().rearViewController.revealViewController().panGestureRecognizer())
            revealViewController().rightViewRevealWidth = 150
            revealViewController().rearViewRevealWidth = 250
        }
        
        threadTable.delegate = self
        threadTable.dataSource = self
        threadTable.rowHeight = UITableViewAutomaticDimension
        threadTable.estimatedRowHeight = 140
        navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        threadTable.backgroundColor = FlatWhite()

        let btn2 = UIButton(type: .custom)
        //btn2.setImage(#imageLiteral(resourceName: "more").maskWithColor(color: tint), for: .normal)
        let moreIcon = FAKMaterialIcons.moreIcon(withSize: 35)
        moreIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        btn2.setAttributedTitle(moreIcon?.attributedString(), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        btn2.addTarget(revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        navigationItem.rightBarButtonItem = item2

        
        setupTheme()
        Async.main{
            self.displayThreads()
        }
        
        
    }
    
    
    func updateThisSubreddit() {
        if let x = revealViewController().rearViewController as? SidebarTableViewController {
            for c in x.sidebarTable.visibleCells {
                if let cell = c as? SubredditTableViewCell {
                    if cell.subredditTitle.currentTitle == subreddit {
                        cell.updateSubreddit()
                    }
                }
            }
        }
    }

    
    
    func setupTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        let n = navigationController!
        switch theme {
        case "mint":
            Theme.setNavbarTheme(navigationController: n, color: FlatMint())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatMintDark()
            
        case "purple":
            Theme.setNavbarTheme(navigationController: n, color: FlatPurple())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatPurpleDark()
            
        case "magenta":
            Theme.setNavbarTheme(navigationController: n, color: FlatMagenta())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatMagentaDark()
            
        case "lime":
            Theme.setNavbarTheme(navigationController: n, color: FlatLime())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatLimeDark()
            
        case "blue":
            Theme.setNavbarTheme(navigationController: n, color: FlatSkyBlue())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatSkyBlue()
            
            
        case "red":
            Theme.setNavbarTheme(navigationController: n, color: FlatRed())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatRed()
            
            
        case "dark":
            Theme.setNavbarTheme(navigationController: n, color: FlatBlack())
            Utils.addMenuButton(color: UIColor.white, navigationItem: navigationItem, revealViewController: revealViewController())
            generalColor = FlatBlack()
            threadTable.backgroundColor = FlatBlackDark()
            self.view.backgroundColor = FlatBlackDark()
            
        case "white":
            Theme.setNavbarTheme(navigationController: n, color: FlatWhite())
            Utils.addMenuButton(color: UIColor.black, navigationItem: navigationItem, revealViewController: revealViewController())
            
            generalColor = FlatBlackDark()
            
        default:
            break
        }
    }
    
    func catchNotification(notification:Notification) -> Void {
        checkCurrentDownloads()
    }
    
    func checkCurrentDownloads() {
        let downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
        print(downloadsInProgress)
        if downloadsInProgress.contains(subreddit) {
            
            overlay?.isHidden = false
            isDownloading = true
            emptyOverlay.isHidden = true
            displayThreads()

        } else {
            displayThreads()
            overlay?.isHidden = true
            isDownloading = false
            if arrayOfThreads.count == 0 {
                print("Array was empty so im making the overlay visible")
                emptyOverlay.isHidden = false
            } else {
                emptyOverlay.isHidden = true
            }
        }

        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        revealViewController().rearViewRevealWidth = 250
        view.addGestureRecognizer(self.revealViewController().rearViewController.revealViewController().panGestureRecognizer())
        checkCurrentDownloads()
        //print(arrayOfThreads)
    }
    
    
    
    
    func displayThreads(sortType:String = "Hot") {
        jsonRaw = Downloader.getJSON(subreddit: subreddit, sortType: sortType)
        if (jsonRaw != "Error") {
            arrayOfThreads.removeAll()
            emptyOverlay.isHidden = true
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let threads = json["data"]["children"]
                // print(json)
                let numOfThreads:Int = Int(UserDefaults.standard.string(forKey: "NumberOfThreads")!)!
                var threadCount = 0
                for (_, thread):(String, JSON) in threads {
                    //if threadCount < numOfThreads {
                    let thisThread = ThreadData()
                    print(thread["data"]["stickied"])
                    //if !(thread["data"]["stickied"].boolValue){
                    thisThread.title = thread["data"]["title"].string!
                    thisThread.author = thread["data"]["author"].string!
                    thisThread.upvotes = thread["data"]["ups"].int!
                    thisThread.commentCount = thread["data"]["num_comments"].int!
                    thisThread.id = thread["data"]["id"].string!
                    thisThread.nsfw = Bool(thread["data"]["over_18"].boolValue)
                    thisThread.permalink = thread["data"]["permalink"].string!
                    thisThread.utcCreated = thread["data"]["created_utc"].double!
                    arrayOfThreads.append(thisThread)
                    //}
                    //}
                threadCount = threadCount + 1
                }
            }
        } else { //It's empty/not downloaded yet
           // emptyOverlay.isHidden = false
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
        
        //Set up font size based on user defaults
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
        
        
        //Set up main labels of cell
        cell.mainText?.text = arrayOfThreads[indexPath.row].title
        cell.authorLabel?.text = "/u/" + arrayOfThreads[indexPath.row].author
        let dateText = Utils.timeAgoSince(Date(timeIntervalSince1970: Double(arrayOfThreads[indexPath.row].utcCreated)))
        cell.hoursText?.text = " • " + String(arrayOfThreads[indexPath.row].upvotes)
        
        //Create attributed string with the upvotes bolded
        let firstWord   = dateText
        let secondWord = String(arrayOfThreads[indexPath.row].upvotes)
                    var attrs:[String:Any] = [:]
        if Theme.getGeneralColor() == FlatBlack() {

        attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size), NSForegroundColorAttributeName: FlatWhite()] as
            [String : Any]
        } else {
          attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size), NSForegroundColorAttributeName: generalColor] as [String : Any]
        }
        let attributedText = NSMutableAttributedString(string:firstWord)
        attributedText.append(NSMutableAttributedString(string: " • "))
        attributedText.append(NSAttributedString(string: secondWord, attributes: attrs))
        cell.hoursText?.attributedText = attributedText
        
        //Set dynamic height
        cell.textLabel?.numberOfLines=0;
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
}



