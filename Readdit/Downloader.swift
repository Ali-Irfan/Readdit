import Foundation
import SwiftyJSON
import Alamofire
import Alamofire_Synchronous
import Zip

let arrayOfSubredditSort = ["Hot", "Controversial", "Top", "Rising", "New"]
let arrayOfThreadSort    = ["Top", "New", "Controversial", "Best", "Old"]

public class Downloader: UIViewController {


    
    class func downloadJSON(subreddit:String){
        // get the default headers
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        // add your custom header
        headers["Accept-Encoding"] = "gzip"
        headers["UserAgent"] = "ios:com.dev.readdit:v1.0.0(by/u/thisbeali)"
        
        // create a custom session configuration
        let configuration = URLSessionConfiguration.default
        // add the headers
        configuration.httpAdditionalHeaders = headers
        
        // create a session manager with the configuration
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        
    var threadNumber = "30"
    if let x = UserDefaults.standard.string(forKey: "NumberOfThreads") {
        threadNumber = x
        print("Using key: " + x)
    }
    
    for sortType in arrayOfSubredditSort {
    
    let urlString = "https://www.reddit.com/r/" + subreddit + "/" + sortType.lowercased() + "/.json?limit=" + threadNumber
    print("Got fresh data from \(urlString)")

        let headers: HTTPHeaders = ["Accept-Encoding": "gzip", "User-Agent": "Readdit iOS App /u/thisbeali alpha"]

            let fileName = subreddit + ".txt"

            let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)

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
            
                let filePath = dir.appending("/" + subreddit + "/thread_" + sortType + "/" + fileName)
            
                let response = Alamofire.request(urlString).responseJSON()
        print(response.request)
        print(response.result)
        
        print("Got the thread")
            let fileContentToWrite = JSON(response.result.value).rawString()
            

            do {
                // Write contents to file
                try fileContentToWrite?.write(toFile: filePath, atomically: false, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
               // print("Successfully wrote data to " + filePath)
                let filePath2 = URL(fileURLWithPath: filePath)
                //let unzipDirectory = try Zip.quickUnzipFile(filePath) // Unzip
                let zipFilePath = try Zip.quickZipFiles([filePath2], fileName: filePath) // Zip
           }
            catch let error as NSError {
                print("An error took place (downloadJSON): \(error)")
           }
       } //END OF LOOP
    }





    
    class func downloadThreadJSON(subreddit: String, threadURL:String, threadID: String){

        for sortType in arrayOfThreadSort {
        let urlString = "https://reddit.com" + threadURL + "/.json?sort=" + sortType

        //let headers: HTTPHeaders = ["Accept-Encoding": "gzip", "User-Agent": "Readdit-iOS-App-/u/thisbeali-alpha"]

                let fileName = threadID + ".txt"
                
                // Fine documents directory on device
                let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)

                    let dir = dirs[0] //documents directory
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let commentSortPath = documentsPath.appendingPathComponent(subreddit + "/comments_" + sortType)
                    do {
                        try FileManager.default.createDirectory(at: commentSortPath!, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }

                    let filePath = dir.appending("/" + subreddit + "/comments_" + sortType + "/" + fileName)
                      print("Local path = \(filePath)")
                    let higherPath = dir.appending("/" + subreddit + "/comments_" + sortType)



            let response = Alamofire.request(urlString).responseJSON()
            
            let fileContentToWrite = JSON(response.result.value).rawString()
            
            do {
                // Write contents to file
                try fileContentToWrite?.write(toFile: filePath, atomically: false, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                // print("Successfully wrote data to " + filePath)
   
                let filePath2 = URL(fileURLWithPath: filePath)
                let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
                let zipFilePath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".zip")
                let oldFilePath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".txt")
                try Zip.zipFiles(paths: [filePath2], zipFilePath: zipFilePath!, password: nil, progress: nil)
                try FileManager.default.removeItem(at: oldFilePath!)
                let filemanager:FileManager = FileManager()
                let files = filemanager.enumerator(atPath: (higherPath))
                while let file = files?.nextObject() {
                    print("Files in dir after download complete:")
                    print(file)
                }
                } catch let error as NSError {
                    print("An error took place(DownloadThread): \(error)")
                }
        }//end of loopZZZ
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
        

            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + subreddit + "/comments_" + sortType + "/" + fileName)
            print("Local path = \(filePath)")

        
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let zipFilePath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".zip")
        let commentFolderPath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/")
        let txtPath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".txt")
        
        
        do {
            try Zip.unzipFile(zipFilePath!, destination: commentFolderPath!, overwrite: true, password: nil, progress: nil)
        } catch let error as NSError {
            print(error)
        }

        do {
            // Read file content
            print("Trying to read content from \(filePath)")
            let contentFromFile = try NSString(contentsOfFile: filePath , encoding: String.Encoding.utf8.rawValue)
            let filemanager:FileManager = FileManager()
            try filemanager.removeItem(at: txtPath!)
            return contentFromFile as String
        }
        catch let error as NSError {
            print("An error took place(GetThread): \(error)")
            return "Error"
        }
    }


    
    
    
}
