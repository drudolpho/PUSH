//
//  UserController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class UserController {
    
    var user: User?
    var friends: [User] = []
    var images: [String: UIImage] = [:]
    var ref = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let df = DateFormatter()
//    var date = Date()
//    for testing future dates
    var date: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 8
        dateComponents.day = 16
        dateComponents.hour = 8
        dateComponents.minute = 33

        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents)!
    }
    
    init() {
        df.dateFormat = "yyyy-MM-dd"
    }
    
    func uploadImage(name: String, image: UIImage) {
        guard let data = image.pngData() else { return }
        
        images[name] = image
        let imageRef = storageRef.child(name)
        _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error saving image to storage \(error)")
                return
            }
            if let _ = metadata {
                print("Error retrieving metadata image to storage ")
                return
            }
        }
    }
    
    func fetchUserData(codeName: String, completion: @escaping (Bool) -> Void) {
        ref.child(codeName).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: Any] else {
                print("There is no data for this user")
                completion(false)
                return
            }
//            print(userDataDictionary)
            if let user = User(dictionary: userDataDictionary) {
                self.user = user
                if let lastDate =  self.df.date(from: user.lastDate) { //check if there is a streak still
                    if self.getDaysSince(day1: lastDate, day2: self.date) > 1 {
                        self.user?.dayStreak = 0
                    }
                }
                self.fetchAllFriendData {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func fetchAllFriendData(completion: @escaping () -> Void) {
        var friends: [String] = UserDefaults.standard.stringArray(forKey: "friends") ?? []
        friendHelper(friends: friends) { badFriends in
            for index in badFriends {
                friends.remove(at: index)
                UserDefaults.standard.set(friends, forKey: "friends")
            }
        }
        completion()
    }
    func friendHelper(friends: [String], completion: @escaping ([Int]) -> Void) {
        var codesToRemove: [Int] = []
        var friendIndex = 0
        for friend in friends {
            ref.child(friend).observeSingleEvent(of: .value) { (snapshot) in
                if let userDataDictionary = snapshot.value as? [String: Any] {
                    if let user = User(dictionary: userDataDictionary) {
                        self.friends.append(user)
                    } else {
                        print("Could not make a user from this data")
                        codesToRemove.append(friendIndex)
                    }
                } else {
                    print("There is no data for this user")
                    codesToRemove.append(friendIndex)
                }
                friendIndex += 1
            }
        }
        completion(codesToRemove)
    }
    
    func findFriendData(codeName: String, completion: @escaping (Bool) -> Void) {
        ref.child(codeName).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: Any] else {
                print("There is no data for this user")
                completion(false)
                return
            }
            if let user = User(dictionary: userDataDictionary) {
                print("friend was found")
                self.friends.append(user)
                var friends: [String] = UserDefaults.standard.stringArray(forKey: "friends") ?? []
                friends.append(codeName)
                UserDefaults.standard.set(friends, forKey: "friends")
                completion(true)
            } else {
                print("friend was not found")
                completion(false)
            }
        }
    }
    
    func submitUserInfo(codeName: String, user: User) {
        ref.child(codeName).setValue(user.dictionaryRepresentation) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            } else {
                print("Data saved successfully!")
                UserDefaults.standard.set(codeName, forKey: "codeName")
            }
        }
    }
    
    func updateUserDatatoServer(completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        
        //update server with new user data
        ref.child(user.codeName).updateChildValues(user.dictionaryRepresentation) { (error, ref) in
            if let error = error {
                print("data not saved correctly \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
    
    func newSet(reps: Int) {
        guard let user = user else { return }
        user.sets += 1
        user.total += reps
        user.avg = user.total / user.sets
        if reps > user.max {
            user.max = reps
        }
        
        if daysSinceLastDate() == 1 { //add to streak
            self.user?.dayStreak += 1
            self.user?.lastDate = df.string(from: date)
            UserDefaults.standard.set(reps, forKey: "todaysPushups")
        } else if daysSinceLastDate() == 0 && user.lastDate == user.startDate { //users first day
            self.user?.dayStreak += 1
            let todaysCount = UserDefaults.standard.integer(forKey: "todaysPushups")
            UserDefaults.standard.set(reps + todaysCount, forKey: "todaysPushups")
        } else if daysSinceLastDate() == 0 { //new set same day
            let todaysCount = UserDefaults.standard.integer(forKey: "todaysPushups")
            UserDefaults.standard.set(reps + todaysCount, forKey: "todaysPushups")
        } else { // streak ended
            self.user?.dayStreak = 1
            self.user?.lastDate = df.string(from: date)
            UserDefaults.standard.set(reps, forKey: "todaysPushups")
        }
    }
    
    func daysSinceLastDate() -> Int {
        guard let user = user else { return 2 }
        if let lastDate =  self.df.date(from: user.lastDate) {
            return self.getDaysSince(day1: lastDate, day2: date)
        } else {
            return 2
        }
    }
    
    func getDaysSince(day1: Date, day2: Date) -> Int {
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: day1)
        let date2 = calendar.startOfDay(for: day2)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
