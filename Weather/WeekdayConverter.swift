//
//  WeekdayConverter.swift
//  MyApp
//
//  Created by R. Tony Goold on 2015-04-16.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation

public class WeekdayConverter {
    public class func convertTimeToWeekday(time: NSTimeInterval) -> String {
        var gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var date = NSDate(timeIntervalSinceReferenceDate: time)
        var weekday = gregorian.component(NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        switch weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
}
