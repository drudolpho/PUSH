//
//  User.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation

class User: Codable {
    var name: String
    var id: UUID
    var codeName: String
    var imageID: String
    var total: Int
    var sets: Int
    var avg: Int
    var max: Int
    var dayStreak: [Date]
    var startDate: Date
    var friends: [UUID]?
    
    init(name: String, id: UUID, codeName: String, imageID: String, total: Int = 0, sets: Int = 0, avg: Int = 0, dayStreak: [Date] = [], max: Int = 0, startDate: Date = Date()) {
        self.name = name
        self.id = id
        self.codeName = codeName
        self.imageID = imageID
        self.total = total
        self.sets = sets
        self.avg = avg
        self.max = max
        self.dayStreak = dayStreak
        self.startDate = startDate
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? UUID,
            let codeName = dictionary["codeName"] as? String,
            let imageID = dictionary["imageID"] as? String,
            let total = dictionary["total"] as? Int,
            let sets = dictionary["sets"] as? Int,
            let avg = dictionary["avg"] as? Int,
            let dayStreak = dictionary["dayStreak"] as? [Date],
            let max = dictionary["max"] as? Int,
            let startDate = dictionary["startDate"] as? Date else { return nil }

        self.init(name: name, id: id, codeName: codeName, imageID: imageID, total: total, sets: sets, avg: avg, dayStreak: dayStreak, max: max, startDate: startDate)
    }
    
    var dictionaryRepresentation: [String: Any] {
        return ["name": name, "id": id, "codeName": codeName, "imageID": imageID, "total": total, "sets": sets, "avg": avg, "dayStreak": dayStreak, "max": max, "startDate": startDate]
      }
}
