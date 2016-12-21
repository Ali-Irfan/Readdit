import Foundation
import SwiftyJSON

let arrayOfSubredditSort = ["hot", "controversial", "top", "rising", "new"]
let arrayOfThreadSort    = ["top", "new", "controversial", "best", "old"]

public class Downloader: UIViewController {
    

    
class func downloadJSON(subreddit:String){

    var threadNumber = "30"
    if let x = UserDefaults.standard.string(forKey: "NumberOfThreads") {
        threadNumber = x
        print("Using key: " + x)
    }
    
    for sortType in arrayOfSubredditSort {
    
    let urlString = "https://www.reddit.com/r/" + subreddit + "/" + sortType + "/.json?limit=" + threadNumber
    print("Got fresh data from \(urlString)")
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            
            let json = JSON(data:data)
            
            
            
            let fileName = subreddit + ".txt"
            
            var filePath = ""

        
            
            // Fine documents directory on device
            let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            
            if dirs.count > 0 {
                let dir = dirs[0] //documents directory
                let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                let subredditPath = documentsPath.appendingPathComponent(subreddit)
                let threadSortPath = documentsPath.appendingPathComponent(subreddit + "/thread_" + sortType)
                do {
                    try FileManager.default.createDirectory(at: subredditPath!, withIntermediateDirectories: true, attributes: nil)
                    try FileManager.default.createDirectory(at: threadSortPath!, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                filePath = dir.appending("/" + subreddit + "/thread_" + sortType + "/" + fileName)
                print("Local path = \(filePath)")
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
                print("An error took place (downloadJSON): \(error)")
            }
            

        }
    }
    }//END OF LOOP
}
    
    
    
    class func downloadThreadJSON(threadURL:String, threadID: String) {//, sortBy: String){


            
        let urlString = "https://reddit.com" + threadURL + "/.json"//?sort=" + sortBy
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
                      print("Local path = \(filePath)")
                    
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
    

    
    
    class func getJSON(subreddit:String, sortType: String) -> String {
        let fileName = subreddit + ".txt"
        var filePath = ""
        // Read file content. Example in Swift
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + subreddit + "/thread_" + sortType + "/" + fileName)
            print("Local path = \(filePath)")
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
    }


    
    
    
}
