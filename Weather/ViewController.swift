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

    var successful = false
    var buffer = NSMutableData()


    var context: NSManagedObjectContext!
    var model: NSManagedObjectModel!

    var fetchController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var request = NSFetchRequest(entityName: "Day")
        request.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: true) ]
        self.fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchController.performFetch(nil)


//        let jsonString = "{ \"longitude\": 123.45, \"latitude\": -34.56 }"
//        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//            handleResponseData(data)
//        }

        self.sendRequest()
    }

    func sendRequest() {
        if let url = NSURL(string: "https://api.forecast.io/forecast/<api key>/43.65,-79.37") {
            var request = NSMutableURLRequest(URL: url)
            // request.HTTPMethod = "POST"
            var connection = NSURLConnection(request: request, delegate: self)
        }
    }


    func handleResponseData(data: NSData) {
        var error: NSError? = nil
        var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        if let dictionary = json as? NSDictionary {
            let latitude = dictionary["latitude"] as? Float
            let longitude = dictionary["longitude"] as? Float
            println("Lat: \(latitude), Long: \(longitude)")
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
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")

        if let day = self.fetchController.objectAtIndexPath(indexPath) as? Day {
            cell.textLabel?.text = day.weekday
            cell.detailTextLabel?.text = "\(day.low) - \(day.high)"
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? DayViewController {
            var ctx = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            ctx.parentContext = self.context
            controller.context = ctx
            controller.model = self.model
        }
    }

    @IBAction func cancelAddDay(segue: UIStoryboardSegue) {

    }

    @IBAction func saveAddDay(segue: UIStoryboardSegue) {
        if let controller = segue.sourceViewController as? DayViewController {
            controller.context.save(nil)
        }
    }
}

