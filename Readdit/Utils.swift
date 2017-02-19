import ReachabilitySwift
import Alamofire
import PMAlertController
import FontAwesomeKit

//Constants
var currentRequests:[Alamofire.Request]? = nil
let updateViewNotification = Notification.Name(rawValue:"UpdateViews")
let updateSubredditNotification = Notification.Name(rawValue:"UpdateSubreddits")


class Utils {
    static  func displayTheAlert(targetVC: UIViewController, title: String, message: String){
        let alert = PMAlertController(title: title, color: Theme.getGeneralColor(), description: message, image: nil, style: .alert)
        alert.addAction((PMAlertAction(title: "OK", style: .cancel, color: Theme.getGeneralColor(), action: { () in
        })))
        targetVC.present(alert, animated: true, completion: nil)
    }
    
    static func hasAppropriateConnection() -> Bool {
        if Reachability()!.isReachable {
            
            let connectionSetting = UserDefaults.standard.string(forKey: "network")
            
            if connectionSetting == "wifi" && Reachability()!.isReachableViaWiFi {
                print("Internet connection OK - wifi only")
                return true
                
            } else if connectionSetting == "data" && !Reachability()!.isReachableViaWiFi {
                print("Internet connection OK - data only")
                return true
                
            } else if connectionSetting == "both" {
                print("Internet connection OK - both")
                return true
                
            }
        } else {
            return false
        }
        return false
    }
    

    static func addMenuButton(color: UIColor, navigationItem: UINavigationItem, revealViewController: SWRevealViewController) {
        let btn1 = UIButton(type: .custom)
        
        //btn1.setImage(#imageLiteral(resourceName: "menu-2").maskWithColor(color: color), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let menuButtonIcon = FAKMaterialIcons.menuIcon(withSize: 30)
        menuButtonIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        btn1.setAttributedTitle(menuButtonIcon?.attributedString(), for: .normal)
        btn1.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        navigationItem.leftBarButtonItem = item1

    }
    
    

    
    static func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }

    

static func removeFilesInSubredditFolder(subreddit: String) {
    let fileManager = FileManager.default
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    let subredditPath = documentsPath.appendingPathComponent(subreddit)
    // Delete 'subfolder' folder
    
    do {
        try fileManager.removeItem(at: subredditPath!)
    }
    catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
				
}
    
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}


 extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
}

}

