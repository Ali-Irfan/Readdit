import UIKit

class CommentViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var upvoteLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var parent_id = ""
    var hiddenComment = false
    var id = ""
    var superParent = ""
    
    @IBOutlet weak var collapseLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainLabel.text = ""
        authorLabel.text = ""
        upvoteLabel.text = ""
        commentCountLabel.text = ""
        collapseLabel.text = "[-]"

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
