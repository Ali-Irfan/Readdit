//
//  ScheduleViewController.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-19.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import DatePickerDialog

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scheduleTable: UITableView!

    var arrayOfTimings: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.rowHeight = 75.0
        if revealViewController() != nil {

            view.addGestureRecognizer(self.revealViewController().frontViewController.revealViewController().panGestureRecognizer())
            revealViewController().rightViewRevealWidth = 0
            revealViewController().rearViewRevealWidth = 250
            let btn1 = UIButton(type: .custom)
            btn1.setImage(#imageLiteral(resourceName: "menu-2"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
            btn1.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            navigationItem.leftBarButtonItem = item1
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfTimings.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.row == 0 {
        let cell = scheduleTable.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddTimeCell
            cell.addTimeButton.addTarget(self, action: #selector(addTime), for: .touchUpInside)
            
            return cell
        } else {
            let cell = scheduleTable.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeCell
            print(indexPath.row)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let time = dateFormatter.string(from: arrayOfTimings[indexPath.row-1])
            cell.timeLabel.text = time
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete && indexPath.row != 0) {
            // handle delete (by removing the data from your array and updating the tableview)
            arrayOfTimings.remove(at: indexPath.row-1)
            scheduleTable.reloadData()
        }
    }
    
    
    func addTime() {
        DatePickerDialog().show(title: "Schedule A Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            self.arrayOfTimings.append(date!)
            self.scheduleTable.reloadData()
            print(date)
        }
    }
}
