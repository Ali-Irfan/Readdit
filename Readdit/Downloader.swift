import Foundation
import SwiftyJSON

public class Downloader: UIViewController {

class func downloadJSON(subreddit:String){

    let urlString = "https://www.reddit.com/r/" + subreddit + "/.json"
    
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            
            let json = JSON(data:data)
            
            
            
            let fileName = subreddit + ".txt"
            var filePath = "~/subreddits"
        
            
            // Fine documents directory on device
            let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            
            if dirs.count > 0 {
                let dir = dirs[0] //documents directory
                filePath = dir.appending("/" + fileName)
              //  print("Local path = \(filePath)")
            } else {
                print("Could not find local directory to store file")
                return
            }
            
            let fileContentToWrite = json.rawString()
            
            do {
                // Write contents to file
                try fileContentToWrite?.write(toFile: filePath, atomically: false, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
               // print("Successfully wrote data to " + filePath)
            }
            catch let error as NSError {
                print("An error took place: \(error)")
            }
            

        }
    }
    }
    
    
    
    class func downloadThreadJSON(threadURL:String, threadID: String){
        
        let urlString = "https://reddit.com" + threadURL + "/.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                
                let json = JSON(data:data)
                
                let fileName = threadID + ".txt"
                var filePath = "~/threads"
                
                
                // Fine documents directory on device
                let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
                
                if dirs.count > 0 {
                    let dir = dirs[0] //documents directory
                    filePath = dir.appending("/" + fileName)
                    //  print("Local path = \(filePath)")
                    
                } else {
                    print("Could not find local directory to store file")
                    return
                }
                
                let fileContentToWrite = json.rawString()
                
                do {
                    // Write contents to file
                    try fileContentToWrite?.write(toFile: filePath, atomically: false, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    print("Successfully wrote data to " + filePath)
                }
                catch let error as NSError {
                    print("An error took place: \(error)")
                }
                
            }
        }
    }
    

    
    
    class func getJSON(subreddit:String) -> String {
        let fileName = subreddit + ".txt"
        var filePath = "~/subreddits"
        // Read file content. Example in Swift
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
           // print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            
        }
        
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            //print(contentFromFile)
            return contentFromFile as String
        }
        catch let error as NSError {
            print("An error took place: \(error)")
            return "Error"
        }
        return "Error"
    }
    
    
    class func getThreadJSON(threadURL:String, threadID: String) -> String {
        let fileName = threadID + ".txt"
        var filePath = "~/threads"
        // Read file content. Example in Swift
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            
        }
        

        do {
            // Read file content
            print("Trying to read content from \(filePath)")
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            
           // print(contentFromFile)
            return contentFromFile as String
        }
        catch let error as NSError {
            print("An error took place: \(error)")
            return "Error"
        }
        return "Error"
    }


    
    
    
}
