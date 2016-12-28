import UIKit
import SwiftyJSON
import Dollar

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let defaults = UserDefaults.standard
    var threadURL = ""
    var subreddit = ""
    var threadID = ""
    var arrayOfComments: [CommentData] = []
    var hiddenChildren: [String] = []

    
    var bleh: [CommentData] = []
    var commentsArr: [CommentData] = []
    var arrayOfEverything: [AnyObject] = []
    @IBOutlet weak var commentTable: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "=", style: .plain, target: revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)))

        let btn2 = UIButton(type: .custom)
        btn2.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn2.addTarget(revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        navigationItem.rightBarButtonItem = item2
       
        
        revealViewController().rearViewRevealWidth = 0
        view.addGestureRecognizer(self.revealViewController().rightViewController.revealViewController().panGestureRecognizer())
        
        
        self.revealViewController().rightViewRevealWidth = 150
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        commentTable.dataSource = self
        commentTable.delegate = self
        commentTable.estimatedRowHeight = 250.0
        commentTable.rowHeight = UITableViewAutomaticDimension
        commentTable.layoutMargins = UIEdgeInsets.zero
        
        

        showThreadComments(sortType: "Best")

        
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
                mainComment.upvotes = json[0]["data"]["children"][0]["data"]["ups"].int!
                bleh.append(mainComment)
                recursion(object: json[1], level: 0)
                commentTable.reloadData()
            }
        }
    }
    
    func sortBy(sortType: String) {
        showThreadComments(sortType: sortType)
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
                comment.utcCreated = child["data"]["created_utc"].int!
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
              
                let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentViewCell

                for view in self.view.subviews {
                    if view.tag == 1 {
                        view.removeFromSuperview()
                    }
                }
                
                
                if bleh[indexPath.row].isMainComment {
                     cell.contentView.layoutMargins.left = 10
                    cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author
                    cell.upvoteLabel?.text = ""
                    cell.collapseLabel?.text = ""
                    let titleText = bleh[indexPath.row].title
                    let selftext = bleh[indexPath.row].selftext
                    if selftext != "" {
                        let firstWord   = titleText
                        let secondWord = "\n\n"
                        let attrs      = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)]
                        let thirdWord   = selftext
                        let attributedText = NSMutableAttributedString(string:firstWord, attributes: attrs)
                        attributedText.append(NSAttributedString(string: secondWord))
                        attributedText.append(NSAttributedString(string: thirdWord))
                        cell.mainLabel?.attributedText = attributedText
                    } else {
                        let firstWord = titleText
                        let attrs2 = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)]
                        let attributedText = NSMutableAttributedString(string:firstWord, attributes: attrs2)
                        cell.mainLabel?.attributedText = attributedText
                    }
                    
                    
                }
                
                if !bleh[indexPath.row].hiddenComment && !bleh[indexPath.row].isMainComment {
                
                        cell.indentationLevel = bleh[indexPath.row].level
                        cell.selectionStyle = .none
                   // cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
                    
                    if cell.indentationLevel > 0 {
                        //cell.seperatorView.isHidden = true
                    }
                    
                        cell.parent_id = bleh[indexPath.row].parent_id
                        cell.id = bleh[indexPath.row].id
                        cell.superParent = bleh[indexPath.row].superParent
                        
                    


                            cell.mainLabel?.text = bleh[indexPath.row].body
                            cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author
                    
                            cell.upvoteLabel?.text = (General.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: Double(bleh[indexPath.row].utcCreated)), numericDates: true)) + " ● " + String(bleh[indexPath.row].upvotes)
                            cell.collapseLabel?.text = bleh[indexPath.row].collapse
                    
                 cell.contentView.layoutMargins.left = CGFloat(bleh[indexPath.row].level * 10) + 10
                    
                    
                    
                  } else {
                    
                }
                
                var initialX = 0
                for i in 0...cell.indentationLevel {
                    print("Cell with author: \(cell.authorLabel?.text) has X: " + String(initialX))
                    let seperatorView = UIView(frame: CGRect(x: initialX, y: 0, width: 1, height: Int(cell.frame.height)))
                    seperatorView.backgroundColor = UIColor.black
                    seperatorView.tag = 1
                    cell.addSubview(seperatorView)
                    initialX = initialX + 10
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
                
                let newIndex = indexPath.row + 1
                if indexPath.row != bleh.count-1 && bleh[indexPath.row].title == "" {
                    let currentIndentationLevel = bleh[indexPath.row].level
                    
                    if bleh[indexPath.row].collapse == "[+]" { //We are now going to open it and all children
                        bleh[indexPath.row].collapse = "[-]"
                        bleh[indexPath.row].minimized = false
                        openAllChildren(parentID: bleh[indexPath.row].id, newIndex: newIndex, currentIndentationLevel: currentIndentationLevel)

                    } else {
                        bleh[indexPath.row].collapse = "[+]" // We are now closing it and all children
                        bleh[indexPath.row].minimized = true
                        closeAllChildren(parentID: bleh[indexPath.row].id, newIndex: newIndex, currentIndentationLevel: currentIndentationLevel)
                    }
                }
                commentTable.reloadData()
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
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

