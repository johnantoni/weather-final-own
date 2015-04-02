//
//  ViewController.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-03-26.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

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

