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
    
    
    
    
    
}



