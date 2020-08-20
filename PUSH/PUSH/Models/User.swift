//
//  User.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import UIKit

class User: Codable {
    var name: String
    var id: String
    var codeName: String
    var imageID: String
    var total: Int
    var sets: Int
    var avg: Int
    var max: Int
    var dayStreak: Int
    var lastDate: String
    var startDate: String
    
    init(name: String, id: String, codeName: String, imageID: String, total: Int = 0, sets: Int = 0, avg: Int = 0, dayStreak: Int = 0, max: Int = 0, lastDate: String, startDate: String) {
        self.name = name
        self.id = id
        self.codeName = codeName
        self.imageID = imageID
        self.total = total
        self.sets = sets
        self.avg = avg
        self.max = max
        self.dayStreak = dayStreak
        self.lastDate = lastDate
        self.startDate = startDate
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let codeName = dictionary["codeName"] as? String,
            let imageID = dictionary["imageID"] as? String,
            let total = dictionary["total"] as? Int,
            let sets = dictionary["sets"] as? Int,
            let avg = dictionary["avg"] as? Int,
            let dayStreak = dictionary["dayStreak"] as? Int,
            let max = dictionary["max"] as? Int,
            let lastDate = dictionary["lastDate"] as? String,
            let startDate = dictionary["startDate"] as? String else { return nil }

        self.init(name: name, id: id, codeName: codeName, imageID: imageID, total: total, sets: sets, avg: avg, dayStreak: dayStreak, max: max, lastDate: lastDate, startDate: startDate)
    }
    
    var dictionaryRepresentation: [String: Any] {
        return ["name": name, "id": id, "codeName": codeName, "imageID": imageID, "total": total, "sets": sets, "avg": avg, "dayStreak": dayStreak, "max": max, "lastDate": lastDate, "startDate": startDate]
      }
}
