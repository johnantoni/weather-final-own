//
//  DayViewController.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-03-26.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var context: NSManagedObjectContext!

    var day: Day?
    var hours: Array<Hour> = []

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Determine the hours for the day
        if let hourSet = self.day?.hours {
            let sortByTime = NSSortDescriptor(key: "time", ascending: true)
            self.hours = hourSet.sortedArrayUsingDescriptors([ sortByTime ]) as! Array<Hour>
            println("There are \(self.hours.count) to display")
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Consider what to return if count == 0
        return hours.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HourCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the display here
        let hour = self.hours[indexPath.row]
        
        // Display the time
        
        // Step 1
        let date = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(hour.time))

        // Step 2
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.NoStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        cell.textLabel?.text = formatter.stringFromDate(date)
        
        // Display the temperature
        let temperature = Int(hour.celsius)
        cell.detailTextLabel?.text = "\(temperature)"
        
        var iconCondition = (hour.condition.lowercaseString).stringByReplacingOccurrencesOfString(" ", withString: "-")

        cell.imageView?.image = UIImage(named: iconCondition)
        println(iconCondition)
        
        return cell
    }

}
