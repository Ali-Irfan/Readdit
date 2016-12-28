import Foundation
import SwiftyJSON
import Alamofire
import Alamofire_Synchronous

let arrayOfSubredditSort = ["Hot", "Controversial", "Top", "Rising", "New"]
let arrayOfThreadSort    = ["Top", "New", "Controversial", "Best", "Old"]

public class Downloader: UIViewController {
    

    
    class func downloadJSON(subreddit:String){

    var threadNumber = "30"
    if let x = UserDefaults.standard.string(forKey: "NumberOfThreads") {
        threadNumber = x
        print("Using key: " + x)
    }
    
    for sortType in arrayOfSubredditSort {
    
    let urlString = "https://www.reddit.com/r/" + subreddit + "/" + sortType.lowercased() + "/.json?limit=" + threadNumber
    print("Got fresh data from \(urlString)")
        
    if let url = URL(string: urlString) {
        let headers: HTTPHeaders = ["Accept-Encoding": "gzip"]
    
     
        
        let response = Alamofire.request(urlString, headers: headers).responseJSON()
        //Alamofire.request(urlString, headers: headers).responseJSON { response in

            let json = JSON(response.result.value!)

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
            

           // }
        }
        }//END OF LOOP

    }





    
    class func downloadThreadJSON(subreddit: String, threadURL:String, threadID: String){

        for sortType in arrayOfThreadSort {

            
        let urlString = "https://reddit.com" + threadURL + "/.json?sort=" + sortType
            if let url = URL(string: urlString) {
                let headers: HTTPHeaders = [
                    "Accept-Encoding": "gzip"
                ]
                
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    documentsURL.appendPathComponent("pigcommments")
                    
                    return (documentsURL.appendingPathComponent(threadID + "_" + sortType + ".gz"), [.removePreviousFile, .createIntermediateDirectories])
                }
                
                //Alamofire.download(urlString, to: destination)
                //Alamofire.download(urlString, headers: headers, to: destination)

                Alamofire.request(urlString, headers: headers).responseJSON { response in
                let json = JSON(response.result.value!)
                    
                let fileName = threadID + ".txt"
                var filePath = ""
                
                // Fine documents directory on device
                let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
                
                if dirs.count > 0 {
                    let dir = dirs[0] //documents directory
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let commentSortPath = documentsPath.appendingPathComponent(subreddit + "/comments_" + sortType)
                    do {
                        try FileManager.default.createDirectory(at: commentSortPath!, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }

                    filePath = dir.appending("/" + subreddit + "/comments_" + sortType + "/" + fileName)
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
                    print("An error took place(DownloadThread): \(error)")
                }
                
            }
        }
        }//end of loop
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
            print("An error took place(getJSON): \(error)")
            return "Error"
        }
        
    }
    
    
    class func getThreadJSON(threadURL:String, threadID: String, sortType: String, subreddit: String) -> String {
        let fileName = threadID + ".txt"
        var filePath = ""
        // Read file content. Example in Swift
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + subreddit + "/comments_" + sortType + "/" + fileName)
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
            print("An error took place(GetThread): \(error)")
            return "Error"
        }
    }


    
    
    
}
