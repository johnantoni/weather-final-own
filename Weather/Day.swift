//
//  Day.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-03-26.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation
import CoreData

@objc(Day)
class Day: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    @NSManaged var weekday: String
    @NSManaged var date: NSTimeInterval
    @NSManaged var high: Float
    @NSManaged var low: Float
    @NSManaged var hours: NSSet

    func addHour(hour: Hour) {
        self.mutableSetValueForKey("hours").addObject(hour)
    }

    func removeHour(hour: Hour) {
        self.mutableSetValueForKey("hours").removeObject(hour)
    }

}
