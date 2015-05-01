//
//  DayImporter.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-04-09.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation

enum MinutelyResult {
    case Success(MinutelyData)
    case Failure(NSError)
}

class DayImporter {

    let json: NSDictionary

    init(json: NSDictionary) {
        self.json = json
    }

    // Using optional return type
    func dictToMinutelyData(dict: NSDictionary) -> MinutelyData? {
        if let time = dict["time"] as? Int {
            if let pop = dict["precipProbability"] as? Float {
                var minutely = MinutelyData()
                minutely.time = time
                minutely.pop = pop
                return minutely
            }
        }
        return nil
    }

    func dictToHourlyData(dict: NSDictionary) -> HourlyData? {
        var time = dict["time"] as? Int
        var summary = dict["summary"] as? String
        var pop = dict["precipProbability"] as? Float
        var temperature = dict["temperature"] as? Float
        if time == nil || summary == nil || pop == nil || temperature == nil {
            return nil
        }
        var hourly = HourlyData()
        hourly.time = time!
        hourly.summary = summary!
        hourly.pop = pop!
        hourly.temperature = temperature!
        return hourly
    }

    func dictToDailyData(dict: NSDictionary) -> DailyData? {
        var time = dict["time"] as? Int
        var summary = dict["summary"] as? String
        var pop = dict["precipProbability"] as? Float
        var tempMin = dict["temperatureMin"] as? Float
        var tempMax = dict["temperatureMax"] as? Float
        if time == nil || summary == nil || pop == nil || tempMin == nil || tempMax == nil {
            return nil
        }
        var daily = DailyData()
        daily.time = time!
        daily.summary = summary!
        daily.pop = pop!
        daily.tempMin = tempMin!
        daily.tempMax = tempMax!
        return daily
    }

    func getData(part: String) -> Array<NSDictionary> {
        if let jsonData = json[part] as? NSDictionary {
            if let array = jsonData["data"] as? Array<NSDictionary> {
                return array
            }
        }
        return []
    }

    func getMinutelyData() -> Array<MinutelyData> {
        var minutelyList = Array<MinutelyData>()
        for minutelyData in getData("minutely") {
            if let minutely = dictToMinutelyData(minutelyData) {
                minutelyList.append(minutely)
            }
        }
        return minutelyList
    }

    func getHourlyData() -> Array<HourlyData> {
        var hourlyList = Array<HourlyData>()
        for hourlyData in getData("hourly") {
            if let hourly = dictToHourlyData(hourlyData) {
                hourlyList.append(hourly)
            }
        }
        return hourlyList
    }

    func getDailyData() -> Array<DailyData> {
        var dailyList = Array<DailyData>()
        for dailyData in getData("daily") {
            if let daily = dictToDailyData(dailyData) {
                dailyList.append(daily)
            }
        }
        return dailyList
    }
}
