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
        commentTable.estimatedRowHeight = 140
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
                mainComment.selftext = mainCommentSelftext
                mainComment.id = json[0]["data"]["children"][0]["data"]["id"].string!
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
                
                    if !alreadyHidden(id: bleh[indexPath.row].id) {
                        cell.indentationLevel = bleh[indexPath.row].level
                        
                        
                        cell.parent_id = bleh[indexPath.row].parent_id
                        cell.id = bleh[indexPath.row].id
                        
                        cell.contentView.layoutMargins.left = CGFloat(bleh[indexPath.row].level * 10) + 10
                        
                        if bleh[indexPath.row].title != "" {
                            cell.mainLabel?.text = bleh[indexPath.row].title + "\n\n" + bleh[indexPath.row].selftext
                        } else {
                            cell.mainLabel?.text = bleh[indexPath.row].body
                            cell.authorLabel?.text = "/u/" + bleh[indexPath.row].author + "   level: " + String(bleh[indexPath.row].level)
                            cell.upvoteLabel?.text = String(bleh[indexPath.row].upvotes)
                            
                            
                        }
                    }
                

               // cell.mainLabel?.numberOfLines=0;
                return cell
            }
    
    
    
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let indexPath = commentTable.indexPathForSelectedRow //optional, to get from any UIButton for example
                let currentCell = commentTable.cellForRow(at: indexPath!) as! CommentViewCell!
                print("Selected cell with author: " + (currentCell?.authorLabel.text)! + " and ID of " + (currentCell?.id)! + " and parent ID of " + (currentCell?.parent_id)!)
                toggleTheChildren(id: (currentCell?.id)!)

                
                commentTable.reloadData()
            
    
            }
    
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if bleh[indexPath.row].hiddenComment == true {
            return 0.0
        }
        return 44.0
    }

    func toggleTheChildren(id: String){
        for (index, cell) in bleh.enumerated() {
            if cell.parent_id == id && !alreadyHidden(id: cell.id) {
                print("Hiding " + cell.body + " - because it's a child of " + cell.parent_id)
                cell.hiddenComment = true//Hide the child

                hiddenChildren.append(cell.id)
                toggleTheChildren(id: cell.id)//Recurse to hide it's children
            } else if (cell.parent_id == id && alreadyHidden(id: cell.id)) {
                print("Showing " + cell.body + " - because it's a child of " + cell.parent_id)
                cell.hiddenComment = false//Hide the child
                hiddenChildren = hiddenChildren.filter() {$0 != cell.id}
                toggleTheChildren(id: cell.id)//Recurse to hide it's children
            }
        }
    }
    
    
    func alreadyHidden(id: String) -> Bool {
        for child in hiddenChildren {
            if child == id {
                return true
            }
        }
        return false
    }
    
}


