import ReachabilitySwift

class Utils {
    static  func displayTheAlert(targetVC: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
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

}

