import UIKit
import SwiftyJSON
import Dollar
import Zip
import ChameleonFramework
import Async
import StringExtensionHTML

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let defaults = UserDefaults.standard
    var threadURL = ""
    var author = ""
    var subreddit = ""
    var threadID = ""
    var arrayOfComments: [CommentData] = []
    var hiddenChildren: [String] = []
    var overlay: UIView!
    var color = UIColor.black
    var bleh: [CommentData] = []
    var commentsArr: [CommentData] = []
    var arrayOfEverything: [AnyObject] = []
    @IBOutlet weak var commentTable: UITableView!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.white
        overlay!.alpha = 0.9
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        if Theme.getGeneralColor() == FlatBlack() {
            overlay!.backgroundColor = FlatBlackDark()
            activityView.color = FlatWhite()
            commentTable.backgroundColor = FlatBlackDark()
            self.view.backgroundColor = FlatBlackDark()
        } else {
            overlay!.backgroundColor = UIColor.white
            activityView.color = Theme.getGeneralColor()
            commentTable.backgroundColor = FlatWhite()
            self.view.backgroundColor = FlatWhite()
        }
        activityView.center = self.view.center
        activityView.startAnimating()
        
        overlay?.addSubview(activityView)
        view.addSubview(overlay!)
        
        addMoreButton()
        
        revealViewController().rearViewRevealWidth = 0
        view.addGestureRecognizer(self.revealViewController().rightViewController.revealViewController().panGestureRecognizer())
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.revealViewController().rightViewRevealWidth = 150
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        commentTable.dataSource = self
        commentTable.delegate = self
        commentTable.estimatedRowHeight = 40.0//250.0
        commentTable.rowHeight = UITableViewAutomaticDimension
        commentTable.layoutMargins = UIEdgeInsets.zero
        
        
        Async.main {
            self.showThreadComments(sortType: "Best")
        }
        
        
    }
    
    

    
    func addMoreButton() {
        var indicatorColor = UIColor()
        let theme = UserDefaults.standard.string(forKey: "theme")!
        var tint = FlatWhite()
        switch theme {
            
        case "mint":
            indicatorColor = UIColor.white
            self.activityView.color = FlatMint()
            color = FlatMintDark()
            
        case "purple":
            indicatorColor = UIColor.white
            self.activityView.color = FlatPurple()
            color = FlatPurpleDark()
            
        case "magenta":
            indicatorColor = UIColor.white
            self.activityView.color = FlatMagenta()
            color = FlatMagentaDark()
            
        case "lime":
            indicatorColor = UIColor.white
            self.activityView.color = FlatLime()
            color = FlatLimeDark()
            
        case "blue":
            indicatorColor = UIColor.white
            self.activityView.color = FlatBlue()
            color = FlatSkyBlue()
            
        case "red":
            indicatorColor = UIColor.white
            self.activityView.color = FlatRed()
            color = FlatRed()
            
            
        case "dark":
            indicatorColor = UIColor.white
            self.activityView.color = FlatBlack()
            color = FlatBlack()
            
            
        case "white":
            indicatorColor = UIColor.black
            self.activityView.color = FlatWhite()
            color = FlatBlack()
            tint = FlatBlack()
            
        default:
            break
        }
        
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(#imageLiteral(resourceName: "more").maskWithColor(color: tint), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        btn2.addTarget(revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        navigationItem.rightBarButtonItem = item2
    }
    
    func showThreadComments(sortType: String) {
        
        let jsonRaw = Downloader.getThreadJSON(threadURL: threadURL, threadID: threadID, sortType: sortType, subreddit: subreddit)
        bleh.removeAll()
        if (jsonRaw != "Error") {
            if let data = jsonRaw.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                let mainCommentTitle = json[0]["data"]["children"][0]["data"]["title"].string!
                let mainCommentSelftext = json[0]["data"]["children"][0]["data"]["selftext"].string!
                let mainComment = CommentData()
                mainComment.title = mainCommentTitle
                mainComment.isMainComment = true
                mainComment.selftext = mainCommentSelftext
                mainComment.id = json[0]["data"]["children"][0]["data"]["id"].string!
                mainComment.author = json[0]["data"]["children"][0]["data"]["author"].string!
                author = mainComment.author
                mainComment.upvotes = json[0]["data"]["children"][0]["data"]["ups"].int!
                bleh.append(mainComment)
                recursion(object: json[1], level: 0)
                commentTable.reloadData()
            }
        }
        overlay.removeFromSuperview()
    }
    
    func sortBy(sortType: String) {
        showThreadComments(sortType: sortType)
        print("Showing thread comments based off of \(sortType)")
    }
    
    func recursion(object: JSON, level: Int = 0){
        
        let children:JSON = object["data"]["children"]
        
        for (_, child):(String, JSON)  in children {
            if child["kind"].string! != "more" {
                let replies:JSON = child["data"]["replies"]
                let comment = CommentData()
                comment.body = child["data"]["body"].string!
                comment.author = child["data"]["author"].string!
                comment.upvotes = child["data"]["ups"].int!
                comment.id = child["data"]["id"].string!
                comment.selftext = ""
                comment.title = ""
                comment.parent_id = child["data"]["parent_id"].string!
                let r = comment.parent_id.index(comment.parent_id.startIndex, offsetBy: 3)..<comment.parent_id.endIndex
                comment.parent_id = comment.parent_id[r]
                //print(comment.parent_id)
                comment.controversiality = child["data"]["controversiality"].int!
                comment.score = child["data"]["score"].int!
                comment.body_html = child["data"]["body_html"].string!
                comment.utcCreated = child["data"]["created_utc"].double!
                comment.level = level
                bleh.append(comment)
                recursion(object: replies, level: level + 1)
            }
        }
    }
    
    
    // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return bleh.count
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentViewCell
        
        var size: CGFloat = 0.0
        
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale //Slightly faster tableviews
        
        if bleh[indexPath.row].isMainComment {
            cell.seperatorView.isHidden = true
            cell.contentView.layoutMargins.left = 10
            cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author
            cell.upvoteLabel?.text = ""
            if bleh[indexPath.row].author == author {
                print("Author is \(bleh[indexPath.row].author), adding BG")
                //cell.authorLabel.backgroundColor = Utils.hexStringToUIColor(hex: "E1E1E1")
                let att      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size), NSForegroundColorAttributeName: color] as [String : Any]
                let attributedText = cell.authorLabel.text
                cell.authorLabel.attributedText = NSAttributedString(string: attributedText!, attributes: att)
                
                
            }
            cell.collapseLabel?.text = ""
            let titleText = bleh[indexPath.row].title.stringByDecodingHTMLEntities
            let selftext = bleh[indexPath.row].selftext.stringByDecodingHTMLEntities
            //print("Current default: \(UserDefaults.standard.string(forKey: "fontSize"))")
            if UserDefaults.standard.string(forKey: "fontSize") == "small" {
                size = 14
                cell.mainLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 12)
                cell.upvoteLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 10)
                cell.authorLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 10)
            } else if UserDefaults.standard.string(forKey: "fontSize") == "regular" {
                size = 16
                cell.mainLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 14)
                cell.upvoteLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 12)
                cell.authorLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 12)
            } else if UserDefaults.standard.string(forKey: "fontSize") == "large" {
                size = 18
                cell.mainLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 16)
                cell.upvoteLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 14)
                cell.authorLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 14)
            }
            if selftext != "" {
                let firstWord   = titleText
                let secondWord = "\n\n"
                let attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)]
                let thirdWord   = selftext
                let attributedText = NSMutableAttributedString(string:firstWord, attributes: attrs)
                attributedText.append(NSAttributedString(string: secondWord))
                attributedText.append(NSAttributedString(string: thirdWord))
                cell.mainLabel?.attributedText = attributedText
                
            } else {
                let firstWord = titleText
                let attrs2 = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)]
                let attributedText = NSMutableAttributedString(string:firstWord, attributes: attrs2)
                
                cell.mainLabel?.attributedText = attributedText
            }
            
            for sep in cell.arrayOfSeperators {
                sep.isHidden = true
            }
            
            
        } else if !bleh[indexPath.row].hiddenComment && !bleh[indexPath.row].isMainComment {
            
            
            
            cell.contentView.layoutIfNeeded()
            
            if (indexPath.row+1) <= indexPath.count {
                if bleh[indexPath.row + 1].level == 0 {
                    for sep in cell.arrayOfSeperators {
                       // print("cell.frame.size.height: \(cell.frame.size.height)")
                        sep.bounds = CGRect(x: sep.bounds.origin.x, y: sep.bounds.origin.y-30, width: sep.bounds.width, height: sep.bounds.height)
                    }
                }
            }
            
            cell.indentationLevel = bleh[indexPath.row].level
            cell.selectionStyle = .none
            // cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
            
            if cell.indentationLevel > 0 {// && !bleh[indexPath.row].minimized {
                cell.seperatorView.isHidden = true
                
            } else {
                cell.seperatorView.isHidden = false
            }
            
            for sep in cell.arrayOfSeperators {
                sep.isHidden = true
            }
            
            
            for i in 0...cell.indentationLevel {
                cell.arrayOfSeperators[i].isHidden = false
                if Theme.getGeneralColor() != FlatBlack() {
                    cell.arrayOfSeperators[i].backgroundColor = Utils.hexStringToUIColor(hex: "DCDCDC")
                } else {
                    cell.arrayOfSeperators[i].backgroundColor = FlatGrayDark()
                }
            }
            
            cell.contentView.layoutMargins.left = CGFloat(cell.indentationLevel * 15) + 10
            
            
            cell.parent_id = bleh[indexPath.row].parent_id
            cell.id = bleh[indexPath.row].id
            cell.superParent = bleh[indexPath.row].superParent
            
            
            
            
            var otherSize:CGFloat = 0.0
            
            if UserDefaults.standard.string(forKey: "fontSize") == "small" {
                otherSize = 10
                cell.mainLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 12)
                cell.upvoteLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 10)
                cell.authorLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 10)
            } else if UserDefaults.standard.string(forKey: "fontSize") == "regular" {
                otherSize = 12
                cell.mainLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 14)
                cell.upvoteLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 12)
                cell.authorLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 12)
            } else if UserDefaults.standard.string(forKey: "fontSize") == "large" {
                otherSize = 14
                cell.mainLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 16)
                cell.upvoteLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 14)
                cell.authorLabel.font = UIFont(name: cell.mainLabel.font.fontName, size: 14)
            }
            
            cell.mainLabel?.text = bleh[indexPath.row].body.stringByDecodingHTMLEntities
            if Theme.getGeneralColor() == FlatBlack() {
                cell.seperatorView.backgroundColor = FlatBlack()
            }
            cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author
            cell.authorLabel.textColor = FlatBlack()//Utils.hexStringToUIColor(hex: "808080")
            if bleh[indexPath.row].author == author {
               // print("Author is \(bleh[indexPath.row].author), adding BG")
                
                //cell.authorLabel.backgroundColor = FlatGray()//Utils.hexStringToUIColor(hex: "E1E1E1")
                cell.authorLabel.textColor = color
                let att      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: otherSize), NSForegroundColorAttributeName: color] as [String : Any]
                let attributedText = cell.authorLabel.text
                cell.authorLabel.attributedText = NSAttributedString(string: attributedText!, attributes: att)
                //cell.authorLabel.textColor = UIColor.white
            } else {
                //cell.authorLabel.backgroundColor = UIColor.white
                cell.authorLabel.textColor = FlatBlack()
                
                
            }
            
            let dateText = Utils.timeAgoSince(Date(timeIntervalSince1970: Double(bleh[indexPath.row].utcCreated)))
            cell.upvoteLabel?.text = " • " + String(bleh[indexPath.row].upvotes)
            
            
            
            let firstWord   = dateText
            let secondWord = String(bleh[indexPath.row].upvotes)
            let attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: otherSize), NSForegroundColorAttributeName: color] as [String : Any]
            let attributedText = NSMutableAttributedString(string:firstWord)
            attributedText.append(NSMutableAttributedString(string: " • "))
            attributedText.append(NSAttributedString(string: secondWord, attributes: attrs))
            cell.upvoteLabel?.attributedText = attributedText
            //cell.upvoteLabel.textColor = Utils.hexStringToUIColor(hex: "808080")
            cell.collapseLabel?.text = bleh[indexPath.row].collapse
            
            
        } else {
            
        }
        
        return cell
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if bleh[indexPath.row].hiddenComment {
            return 0.00
        } else if bleh[indexPath.row].minimized {
            return 40.00
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow! //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath) as! CommentViewCell
        
        //print("I clicked on cell with author: \(currentCell.authorLabel.text)")
        
        
        let newIndex = indexPath.row + 1
        if indexPath.row != bleh.count-1 && bleh[indexPath.row].title == "" {
            let currentIndentationLevel = bleh[indexPath.row].level
            
            if bleh[indexPath.row].collapse == "[+]" { //We are now going to open it and all children
                bleh[indexPath.row].collapse = "[-]"
                bleh[indexPath.row].minimized = false
                
                //currentCell.seperatorView.isHidden = false
                //print("Seperatorview for author \(currentCell.authorLabel.text) is now hidden: \(currentCell.seperatorView.isHidden) with width val: \(currentCell.seperatorView.frame.width) and height \(currentCell.seperatorView.frame.height)")
                openAllChildren(parentID: bleh[indexPath.row].id, newIndex: newIndex, currentIndentationLevel: currentIndentationLevel)
                
            } else {
                bleh[indexPath.row].collapse = "[+]" // We are now closing it and all children
                bleh[indexPath.row].minimized = true
                closeAllChildren(parentID: bleh[indexPath.row].id, newIndex: newIndex, currentIndentationLevel: currentIndentationLevel)
            }
        }
        //commentTable.beginUpdates()
        //commentTable.endUpdates()
        //commentTable.reloadData()
        Async.main{
            self.commentTable.reloadRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
    
    
    func openAllChildren(parentID: String, newIndex: Int, currentIndentationLevel: Int){
        var newIndex = newIndex
        while bleh[newIndex].level > currentIndentationLevel && newIndex <= bleh.count{
            bleh[newIndex].hiddenComment = false
            bleh[newIndex].collapse = "[+]"
            newIndex = newIndex + 1
            if newIndex >= bleh.count {
                break
            }
        }
    }
    
    func closeAllChildren(parentID: String, newIndex: Int, currentIndentationLevel: Int){
        var newIndex = newIndex
        while bleh[newIndex].level > currentIndentationLevel && newIndex <= bleh.count{
            bleh[newIndex].hiddenComment = true
            bleh[newIndex].collapse = "[-]"
            newIndex = newIndex + 1
            if newIndex >= bleh.count {
                break
            }
        }
    }
    
    
}


