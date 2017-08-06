import Foundation
import SwiftyJSON
import Alamofire
import Alamofire_Synchronous
import Zip
import SwiftyJSON
import Async
import SDWebImage

var Network = NetworkManager().manager!
let arrayOfSubredditSort = ["Hot", "Controversial", "Top", "Rising", "New"]
let arrayOfThreadSort    = ["Top", "New", "Controversial", "Best", "Old", "QA"]
var request:Alamofire.Request?
var lastImgURL = ""
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
        Network.session.configuration.timeoutIntervalForRequest = 10

        
        
        let threadNumber = UserDefaults.standard.string(forKey: "NumberOfThreads")

        
        for sortType in arrayOfSubredditSort {

            var urlString = "https://www.reddit.com/r/"
                urlString.append(subreddit)
                urlString.append("/" + sortType.lowercased() + "/.json?limit=" + threadNumber!)
            //print("Getting data from URL: \(urlString)")
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
                //print("Download Progress: \(progress.fractionCompleted)")
                }.validate(statusCode: 200..<300).response{ response in
                    completed = true
            }
            while !completed {
                //print("Not completed yet...")
            }
            //print("Completed subreddit!")

        } //END OF LOOP
    }
    
    
    
    class func downloadThreadJSON(subreddit: String, threadURL:String, threadID: String) {
        let group = AsyncGroup()

        for sortType in arrayOfThreadSort {
            
            group.enter()
            
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
                //.validate(statusCode: 200..<300)
                .response{ response in
                    //print(response.response?.statusCode)
                    do {
                        
                        //Now that the thread info is downloaded, download the image if it has one
                        do {
                            let imageFileExtensions = ["jpg", "png", "jpeg", "gif", "gifv"]
                            let downloadedJSON = try String(contentsOf: filePath!, encoding: String.Encoding.utf8)
                            let json = JSON(data: downloadedJSON.data(using: String.Encoding.utf8)!)
                            let imageURL:NSString = json[0]["data"]["children"][0]["data"]["url"].string as! NSString
                            let imgExtension = imageURL.pathExtension
                            var url:URL = URL(string: imageURL as String)!
                            
                            do {
                                try FileManager.default.createDirectory(at: documentsPath.appendingPathComponent(subreddit + "/images")!, withIntermediateDirectories: true, attributes: nil)
                            } catch let error as NSError {
                                NSLog("Unable to create directory \(error.debugDescription)")
                            }
                            
                            let imgDestination: DownloadRequest.DownloadFileDestination = { _, _ in
                                let fileURL = documentsPath.appendingPathComponent("/" + subreddit + "/images/" + threadID + ".gif")
                                return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
                                //
                            }

                            if imageFileExtensions.contains(imgExtension) {
//                                let compressedURL:URL = getCompressedURL(sentURL: url.absoluteString)
//                                Network.download(compressedURL, to: imgDestination).response{ response in
//                                 print(response)
//                                }
                                getCompressedURL(sentURL: url.absoluteString) { (cURL) -> () in
                                    print("CURL: " + cURL)
                                    Network.download(URL(string: cURL)!, to: imgDestination)
                                }
                            }
                            
                    
                            
                            
                            
                            
                            //Replace all extenions with gif
                            
                            //If it's an imgur file
                            
                            //If it's an imgur album
                            
                            //If it's a not those, but ends in png, jpg, jpeg, gif, gifv
                            
                            //MAKE SURE IM NOT DOWNLOADING A PLAIN GIF FILE FOR TESTING
                            
                            
                            
//                            if imageFileExtensions.contains((imageURL.pathExtension?.lowercased())!) {
//                                //print(imageURL.pathExtension)
//                                directURL = imageURL as String
//                                directURL = directURL.replacingOccurrences(of: "http://", with: "")
//                                directURL = directURL.replacingOccurrences(of: "https://", with: "")
//                                var realURL = ""
//
//                                if directURL.contains(".gifv") {
//                                    directURL = directURL.replacingOccurrences(of: ".gifv", with: ".gif")
//                                    realURL = directURL
//                                    print("Downloading \(realURL)")
//                                } else {
//                                    realURL = "https://images.weserv.nl/?url="+directURL+"&w=700&q=60"
//                                    print("Downloading \(realURL)")
//
//                                }

//                                Network.download(realURL, to: imgDestination)
//
//                            if imageURL.lowercased.contains("imgur.com") {
//                                //print("It's an IMGUR")
//                                var realURL = ""
//
//                                if imageURL.contains(".gifv") || imageURL.contains(".gif") {
//                                    directURL = "i.imgur.com/" + imageName + ".gif"
//                                    realURL = directURL
//                                    print("Downloading \(realURL)")
//
//                                } else {
//                                    //realURL = "https://images.weserv.nl/?url="+directURL+"&w=700&q=60"
//                                    realURL = directURL
//                                    print("Downloading \(realURL)")
//
//                                }
                            
//
//                            }
                            
//                            }
                        
                        
                            
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
                    group.leave()

            }
            
        }
        group.wait()
    
    }

    
    
    
    class func getCompressedURL(sentURL: String, completed: @escaping (String) -> Void) {
        Network.session.configuration.timeoutIntervalForRequest = 30
        Network.session.configuration.timeoutIntervalForResource = 30
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 300
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 300

        let moddedURL = sentURL.replacingOccurrences(of: "http:", with: "https:")
        let newURL = "https://api.gifs.com/media/import?source=\(moddedURL)"
        let urlToUse:URL = URL(string: newURL)!
        var cURL:String = ""
        print("Using newURL: \(newURL)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 300
        configuration.timeoutIntervalForRequest = 300
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        SessionManager.default.session.configuration.timeoutIntervalForRequest = 300

        Alamofire.request(urlToUse).responseJSON { response in
            print(response)
            if let value = response.result.value {
                let json = JSON(value)
                cURL = json["success"]["files"]["gif"].string!
                completed(cURL)
            }

        }
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
            //print("Local path = \(filePath)")
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

        //print("Fetching thread comments from= \(filePath)")
        
        
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
            //print("Trying to read content from \(filePath)")
            let contentFromFile = try NSString(contentsOfFile: filePath , encoding: String.Encoding.utf8.rawValue)
            let filemanager:FileManager = FileManager()
            try filemanager.removeItem(at: txtPath!)
            //print("Removed item at \(txtPath)")
            return contentFromFile as String
        }
        catch let error as NSError {
            print("An error took place(GetThread): \(error)")
            return "Error"
        }
    }
}
