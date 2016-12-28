
//
//  ClearAllDataTableViewCell.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-11-30.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit

class ClearAllDataTableViewCell: UITableViewCell {

    @IBOutlet weak var clearData: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clearAll(_ sender: Any) {
            
        let fileManager = FileManager.default
        //let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsUrl =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    
                    //if (fileName.hasSuffix(".png"))
                    //{
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    //}
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
                clearData.setTitle("Clear All Data (" + getCacheSize() + ")", for: .normal)
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
