import Foundation
import UIKit

class General {
class func subredditExists(fileName: String) -> Bool {
    var filePath = "~/subreddits"
    // Read file content. Example in Swift
    // Fine documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    if dirs.count > 0 {
        let dir = dirs[0] //documents directory
        filePath = dir.appending("/" + fileName)
        // print("Local path = \(filePath)")
    }
    
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath) {
        return true
    } else {
        return false
    }

}

class func threadExists(fileName: String) -> Bool {
    var filePath = "~/threads"
    // Read file content. Example in Swift
    // Fine documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    if dirs.count > 0 {
        let dir = dirs[0] //documents directory
        filePath = dir.appending("/" + fileName)
        // print("Local path = \(filePath)")
    }
    
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath) {
        return true
    } else {
        return false
    }
    
}


}
