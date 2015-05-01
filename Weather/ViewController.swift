//
//  ViewController.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-03-26.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, NSURLConnectionDataDelegate {

    @IBOutlet var tableView: UITableView!

    var successful = false
    var loaded = false
    var buffer = NSMutableData()

    var context: NSManagedObjectContext!

    var fetchController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Only automatically fetch the temperatures once
        if loaded {
            return
        }

        var request = NSFetchRequest(entityName: "Day")
        request.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: true) ]
        self.fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchController.performFetch(nil)

        self.sendRequest()

        loaded = true
    }

    func sendRequest() {
        if let url = NSURL(string: "https://api.forecast.io/forecast/e0ad861e183017092cec7fb188c2d787/43.65,-79.37") {
            var request = NSMutableURLRequest(URL: url)
            var connection = NSURLConnection(request: request, delegate: self)
        }
    }


    func handleResponseData(data: NSData) {
        var error: NSError? = nil
        var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        if let dictionary = json as? NSDictionary {
            var importer = DayImporter(json: dictionary)
            var hoursData = importer.getHourlyData()
            var daysData = importer.getDailyData()

            // Create a new context to make this transactional (we need to specify
            // a concurrency type but the choice isn't important to us right now).
            var transaction = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)

            // The transaction's parent is our main context, so it will start off
            // as a snapshot of the main context and save changes back to it
            transaction.parentContext = self.context

            // We want to replace everything, so delete what's already there.
            // Because we're doing this in a child context, if something goes wrong,
            // we can return without saving the child context and everything will
            // be fine.
            for object in transaction.registeredObjects {
                transaction.deleteObject(object as! NSManagedObject)
            }

            // This will convert our data into Core Data model objects
            var converter = DayConverter(context: transaction)

            var days = Array<Day>()
            for data in daysData {
                days.append(converter.dayFromDailyData(data))
            }

            for data in hoursData {
                let hour = converter.hourFromHourlyData(data)
                let hourTime = NSTimeInterval(hour.time)
                // We get hourly data for more than one day, find the one it belongs to
                for day in days {
                    let dayTime = day.date
                    // There are 86400 seconds in a day, see if this hour falls
                    // within the time interval for the day
                    if hourTime >= dayTime && hourTime < dayTime + 86400 {
                        day.addHour(converter.hourFromHourlyData(data))
                        break
                    }
                }
            }

            // Okay, looks like nothing blew up, let's finish the transaction by
            // saving the context
            var error: NSError? = nil
            if !transaction.save(&error) {
                println("Failed to save changes: \(error)")
                return;
            }

            // Finally, refresh the table to display the new results
            if self.fetchController.performFetch(&error) {
                self.tableView.reloadData()
            }
            else {
                println("Failed to fetch results: \(error)")
            }
        }
        else if error != nil {
            println("Failed to decode JSON: \(error!)")
        }
    }

    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        if let httpResponse = response as? NSHTTPURLResponse {
            let status = httpResponse.statusCode
            println("didReceiveResponse: \(status) \(NSHTTPURLResponse.localizedStringForStatusCode(status))")
            if status >= 200 && status < 400 {
                self.successful = true
            }
        }
        self.buffer.length = 0
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        println("didReceiveData: \(data.length) bytes")
        self.buffer.appendData(data)

        // Update progress bar?
    }

    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("connectionDidFinishLoading")
        // Do stuff with the response
        self.handleResponseData(self.buffer)

        // Be kind, free up memory
        self.buffer.length = 0
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.successful = false
        println("Failed: \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchController.sections {
            if sections.count > 0 {
                return sections[0].numberOfObjects!
            }
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath) as! UITableViewCell

        if let day = self.fetchController.objectAtIndexPath(indexPath) as? Day {
            cell.textLabel?.text = day.weekday
            // Convert to int to round it (or else we get too many decimals)
            let low = Int(day.lowCelsius)
            let high = Int(day.highCelsius)
            cell.detailTextLabel?.text = "\(low) - \(high) C"
        }

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? DayViewController {
            // This segue occurs when tapping on a table cell, so the sender is the cell
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)

            // What comes next? What information do you need to pass on?
            if let day = self.fetchController.objectAtIndexPath(indexPath!) as? Day {
                controller.day = day
            }
            controller.context = self.context
            
        }
    }
}

