//
//  DayViewController.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-03-26.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController {

    var context: NSManagedObjectContext!
    var model: NSManagedObjectModel!
    @IBOutlet var weekdayField: UITextField!
    @IBOutlet var lowField: UITextField!
    @IBOutlet var highField: UITextField!

    var day: Day!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let entity = self.model.entitiesByName["Day"] as NSEntityDescription
        self.day = Day(entity: entity, insertIntoManagedObjectContext: context)
        self.day.weekday = "Thursday"
        self.day.date = NSDate().timeIntervalSinceReferenceDate + 60 * 60 * 24 * 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.day.weekday = self.weekdayField.text
        self.day.low = 10.0
        self.day.high = 20.0
    }

}
