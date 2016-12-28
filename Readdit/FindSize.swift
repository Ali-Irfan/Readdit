func getCacheSize() -> String {
    
let documentsDirectoryURL =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
var bool: ObjCBool = false
if FileManager().fileExists(atPath: documentsDirectoryURL.path, isDirectory: &bool) {
    if bool.boolValue {
        let fileManager =  FileManager.default
        var folderFileSizeInBytes = 0

        if let filesEnumerator = fileManager.enumerator(at: documentsDirectoryURL, includingPropertiesForKeys: nil, options: [], errorHandler: {
            (url, error) -> Bool in
            print(url.path)
            print(error.localizedDescription)
            return true
        }) {
            while let fileURL = filesEnumerator.nextObject() as? NSURL {
                do {
                    let attributes = try fileManager.attributesOfItem(atPath: fileURL.path!) as NSDictionary
                    folderFileSizeInBytes += attributes.fileSize().hashValue
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        let  byteCountFormatter =  ByteCountFormatter()
        byteCountFormatter.allowedUnits = .useAll
        byteCountFormatter.countStyle = .file
        let folderSizeToDisplay = byteCountFormatter.string(fromByteCount: Int64(folderFileSizeInBytes))
        
        print(folderSizeToDisplay)
        return folderSizeToDisplay// "X,XXX,XXX bytes"
    }
}
    return ""
}
