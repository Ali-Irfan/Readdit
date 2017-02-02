import UIKit
import ChameleonFramework
import Async

class CommentViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var upvoteLabel: UILabel!
    

    @IBOutlet weak var sep1: UIView!
    @IBOutlet weak var sep2: UIView!
    @IBOutlet weak var sep3: UIView!
    @IBOutlet weak var sep4: UIView!
    @IBOutlet weak var sep5: UIView!
    @IBOutlet weak var sep6: UIView!
    @IBOutlet weak var sep7: UIView!
    @IBOutlet weak var sep8: UIView!
    @IBOutlet weak var sep9: UIView!
    @IBOutlet weak var sep10: UIView!
    @IBOutlet weak var sep11: UIView!
    @IBOutlet weak var sep12: UIView!
    
    
    var arrayOfSeperators: [UIView] = []
    
    var parent_id = ""
    var hiddenComment = false
    var leftSideSet = false
    var id = ""
    var superParent = ""
    @IBOutlet weak var collapseLabel: UILabel!
    
    @IBOutlet weak var seperatorView: UIView!
        override func awakeFromNib() {
            arrayOfSeperators = [sep1, sep2, sep3, sep4, sep5, sep6, sep7, sep8, sep9, sep10, sep11, sep12]
            for v in arrayOfSeperators {
                v.isHidden = true
            }
        super.awakeFromNib()
        mainLabel.text = ""
        authorLabel.text = ""
        upvoteLabel.text = ""
        collapseLabel.text = "[-]"
            
            let theme = UserDefaults.standard.string(forKey: "theme")!
            switch theme {
                
            case "dark":
                self.backgroundColor = FlatBlackDark()
                for v in arrayOfSeperators {
                    v.backgroundColor = FlatBlack()
                }
                self.authorLabel.textColor = FlatWhite()
                self.mainLabel.textColor = FlatWhite()
                self.upvoteLabel.textColor = FlatWhite()
                
            default:
                self.backgroundColor = UIColor.white
                
                print("Set color to flatwhite")
            }

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
