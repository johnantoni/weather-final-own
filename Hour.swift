//
//  Hour.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-04-02.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation
import CoreData

@objc(Hour)
class Hour: NSManagedObject {

    @NSManaged var condition: String
    @NSManaged var pop: Float
    @NSManaged var temperature: Float
    @NSManaged var time: Int32
    @NSManaged var day: Day

    var celsius: Float {
        get {
            // Conversion to celsius
            return (temperature - 32.0) * 5.0 / 9.0
        }
    }
}
