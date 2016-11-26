import UIKit
import SwiftyJSON
import Dollar

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var threadURL = ""
    var threadID = ""
    var arrayOfComments: [CommentData] = []
    var hiddenChildren: [String] = []
    
    var bleh: [CommentData] = []
    var commentsArr: [CommentData] = []
    var arrayOfEverything: [AnyObject] = []
    @IBOutlet weak var commentTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.dataSource = self
        commentTable.delegate = self
        commentTable.estimatedRowHeight = 250.0
        commentTable.rowHeight = UITableViewAutomaticDimension
        commentTable.layoutMargins = UIEdgeInsets.zero
        
        let jsonRaw = Downloader.getThreadJSON(threadURL: threadURL, threadID: threadID)
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
            }
        }
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
                print(comment.parent_id)
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
              
             //   let cell:CommentViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "commentCell") as! CommentViewCell
                let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentViewCell
                

                if bleh[indexPath.row].isMainComment {
                    cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author
                    cell.upvoteLabel?.text = ""
                    cell.collapseLabel?.text = ""
                    cell.mainLabel?.text = bleh[indexPath.row].title + bleh[indexPath.row].selftext
                    
                }
                
                if !bleh[indexPath.row].hiddenComment && !bleh[indexPath.row].isMainComment {
                
                        cell.indentationLevel = bleh[indexPath.row].level
                        cell.selectionStyle = .none

                    
                        cell.parent_id = bleh[indexPath.row].parent_id
                        cell.id = bleh[indexPath.row].id
                        cell.superParent = bleh[indexPath.row].superParent
                        
                        cell.contentView.layoutMargins.left = CGFloat(bleh[indexPath.row].level * 10) + 10
                        

                            cell.mainLabel?.text = bleh[indexPath.row].body
                            cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author + "   level: " + String(bleh[indexPath.row].level)
                            cell.upvoteLabel?.text = String(bleh[indexPath.row].upvotes)
                            cell.collapseLabel?.text = bleh[indexPath.row].collapse
                    
                 
                    
                  } else {
                    
                }
                return cell
                

               
            }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if bleh[indexPath.row].hiddenComment {
            return 0.00
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

                if indexPath.row != bleh.count-1 || indexPath.row == 0 {
                    let currentIndentationLevel = bleh[indexPath.row].level
                    
                    if bleh[indexPath.row].collapse == "[+]" {
                        bleh[indexPath.row].collapse = "[-]"
                    } else {
                        bleh[indexPath.row].collapse = "[+]"
                    }
                    var newIndex = indexPath.row + 1
                    while bleh[newIndex].level > currentIndentationLevel && newIndex <= bleh.count{
                        if bleh[newIndex].hiddenComment == true {
                            bleh[newIndex].hiddenComment = false
                            
                        } else {
                            bleh[newIndex].hiddenComment = true
                            
                        }
                        
                        newIndex = newIndex + 1
                        if newIndex >= bleh.count {
                            break
                        }
                    }
                }
                
                
                commentTable.reloadData()
                
            }


    
}


