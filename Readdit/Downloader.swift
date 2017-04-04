import Foundation
import SwiftyJSON
import Alamofire
import Alamofire_Synchronous
import Zip
import SwiftyJSON


var Network = NetworkManager().manager!


let arrayOfSubredditSort = ["Hot", "Controversial", "Top", "Rising", "New"]
let arrayOfThreadSort    = ["Top", "New", "Controversial", "Best", "Old", "QA"]
var request:Alamofire.Request?
public class Downloader: UIViewController {
    
    
    class func stopDownloads() {
        downloadsAreStopped = true
        print("Stopped download")
        
        var downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
        
        //Remove current subreddit from downloads in progress array
        downloadsInProgress.removeAll()
        UserDefaults.standard.set(downloadsInProgress, forKey: "inProgress")

    }
    
    
    class func downloadJSON(subreddit:String){
        var completed:Bool = false
        
        
        
        let threadNumber = UserDefaults.standard.string(forKey: "NumberOfThreads")

        
        for sortType in arrayOfSubredditSort {

            var urlString = "https://www.reddit.com/r/"
                urlString.append(subreddit)
                urlString.append("/" + sortType.lowercased() + "/.json?limit=" + threadNumber!)
            print("Getting data from URL: \(urlString)")
            let fileName = subreddit + ".txt"
            
            let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let subredditPath = documentsPath.appendingPathComponent(subreddit)
            let threadSortPath = documentsPath.appendingPathComponent(subreddit + "/thread_" + sortType)
            do {
                try FileManager.default.createDirectory(at: subredditPath!, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: threadSortPath!, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let fileURL = documentsPath.appendingPathComponent("/" + subreddit + "/thread_" + sortType + "/" + fileName)
                return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            
            
             request = Network.download(urlString, to: destination).downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                }.validate(statusCode: 200..<300).response{ response in
                    completed = true
            }
            while !completed {
                //print("Not completed yet...")
            }
            print("Completed subreddit!")

        } //END OF LOOP
    }
    
    
    
    class func downloadThreadJSON(subreddit: String, threadURL:String, threadID: String) {
        for sortType in arrayOfThreadSort {
            let urlString = "https://reddit.com" + threadURL + "/.json?sort=" + sortType.lowercased()
            let fileName = threadID + ".txt"
            let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let commentSortPath = documentsPath.appendingPathComponent(subreddit + "/comments_" + sortType)
            
            //Create a folder for each type of sorting style
            do {
                try FileManager.default.createDirectory(at: commentSortPath!, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            let filePath = documentsPath.appendingPathComponent("/" + subreddit + "/comments_" + sortType + "/" + fileName)
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let fileURL = documentsPath.appendingPathComponent("/" + subreddit + "/comments_" + sortType + "/" + fileName)
                return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
            }
            //print("Created file path for thread with ID: \(threadID)")
            usleep(100000)//Don't overloadserver requests for 429
            request = Network.download(urlString, to: destination).downloadProgress { progress in

                }
                .validate(statusCode: 200..<300)
                .response{ response in
                    //print(response.response?.statusCode)
                    do {
                        
                        //Now that the thread info is downloaded, download the image if it has one
                        do {
                            let imageFileExtensions = ["jpg", "png", "jpeg", "gif", "gifv"]
                            let downloadedJSON = try String(contentsOf: filePath!, encoding: String.Encoding.utf8)
                            let json = JSON(data: downloadedJSON.data(using: String.Encoding.utf8)!)
                            var directURL:String
                            let imageURL:NSString = json[0]["data"]["children"][0]["data"]["url"].string as! NSString
                            print("url of image: \(imageURL)")
                            let imageName = imageURL.pathComponents[2]
                            print(imageName)
                            
                            let imgDestination: DownloadRequest.DownloadFileDestination = { _, _ in
                                let fileURL = documentsPath.appendingPathComponent("/" + subreddit + "/images/" + threadID)
                                return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
                            }
                            
                            if imageFileExtensions.contains(imageURL.pathExtension.lowercased()) {
                                print(imageURL.pathExtension)
                                directURL = imageURL as String
                                Network.download(directURL, to: imgDestination)

                            } else if imageURL.lowercased.contains("imgur.com") {
                                print("It's an IMGUR")
                                directURL = "https://i.imgur.com/" + imageName + ".png"
                                print("Downloading imgur from: " + directURL)
                                Network.download(directURL, to: imgDestination)

                            }
                            

                        
                        
                            
                        }
                        catch {/* error handling here */}
                        
                        //Zip the files after they are downloaded and remove their original file
                        let zipFilePath = documentsPath.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".zip")
                        let txtFilePath = documentsPath.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".txt")
                        try Zip.zipFiles(paths: [filePath!], zipFilePath: zipFilePath!, password: nil, progress: nil)
                        try FileManager.default.removeItem(at: txtFilePath!)

                        downloadDictionary[subreddit] = downloadDictionary[subreddit]! + 1

                    } catch let error as NSError {
                        print("An error took place(DownloadThread): \(error) with filepath: \(threadID)")
                        downloadDictionary[subreddit] = downloadDictionary[subreddit]! + 1

                    }
            }
            
        }
    }
    
    
    
    class func downloadThreadImage(subreddit: String, threadURL: String, threadID: String) {
//    
//        Network.request("https://reddit.com/" + subreddit + "/.json") .responseJSON
//            {
//                (data) in
//                var jsonRaw = ""
//                let dataa = jsonRaw.data(using: String.Encoding.utf8)
//                var json = JSON(data: dataa!)
//                
//                print(json)
//                
//        }

    }
    
    
    class func getJSON(subreddit:String, sortType: String) -> String {
        
        let fileName = subreddit + ".txt"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + subreddit + "/thread_" + sortType + "/" + fileName)
            let downloadsInProgress = UserDefaults.standard.object(forKey: "inProgress") as! [String]
            while !FileManager.default.fileExists(atPath: filePath) && downloadsInProgress.contains(subreddit){
                //print("File doesn't exist)")
            }
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            
        }
        
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            return contentFromFile as String
        }
        catch let error as NSError {
            print("An error took place(getJSON): \(error)")
            return "Error"
        }
        
    }
    
    
    class func getThreadJSON(threadURL: String, threadID: String, sortType: String, subreddit: String) -> String {
        let fileName = threadID + ".txt"
        var filePath = ""
        // Read file content. Example in Swift
        // Fine documents directory on device
        
        
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        
        let dir = dirs[0] //documents directory
        filePath = dir.appending("/" + subreddit + "/comments_" + sortType + "/" + fileName)

        print("Fetching thread comments from= \(filePath)")
        
        
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let zipFilePath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".zip")
        let commentFolderPath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/")
        let txtPath = documentsFolder.appendingPathComponent(subreddit + "/comments_" + sortType + "/" + threadID + ".txt")
        
        do {
            //Unzip the file in directory to read it
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
            print("Removed item at \(txtPath)")
            return contentFromFile as String
        }
        catch let error as NSError {
            print("An error took place(GetThread): \(error)")
            return "Error"
        }
    }
}
