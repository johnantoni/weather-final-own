//
//  DayConverter.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-04-09.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation
import CoreData

class DayConverter {
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func hourFromHourlyData(data: HourlyData) -> Hour {
        var hour = NSEntityDescription.insertNewObjectForEntityForName("Hour", inManagedObjectContext: context) as! Hour
        hour.time = Int32(data.time)
        hour.temperature = data.temperature
        hour.condition = data.summary
        hour.pop = data.pop
        return hour
    }

    func dayFromDailyData(data: DailyData) -> Day {
        var day = NSEntityDescription.insertNewObjectForEntityForName("Day", inManagedObjectContext: context) as! Day
        day.date = NSTimeInterval(data.time)
        day.weekday = WeekdayConverter.convertTimeToWeekday(day.date)
        day.low = data.tempMin
        day.high = data.tempMax
        return day
    }
}
