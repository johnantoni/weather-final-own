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

    @NSManaged var weekday: String
    @NSManaged var date: NSTimeInterval
    @NSManaged var high: Float
    @NSManaged var low: Float
    @NSManaged var hours: NSSet

    var highCelsius: Float {
        get {
            // Conversion to celsius
            return (high - 32.0) * 5.0 / 9.0
        }
    }

    var lowCelsius: Float {
        get {
            return (low - 32.0) * 5.0 / 9.0
        }
    }

    func addHour(hour: Hour) {
        self.mutableSetValueForKey("hours").addObject(hour)
    }

    func removeHour(hour: Hour) {
        self.mutableSetValueForKey("hours").removeObject(hour)
    }

}
