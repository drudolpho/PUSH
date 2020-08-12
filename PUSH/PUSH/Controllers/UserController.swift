//
//  UserController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserController {
    
    var user: User?
    var friends: [User] = []
    var updateCollectionView: (() -> Void)?
    var ref = Database.database().reference()
    let df = DateFormatter()
    
    init() {
        df.dateFormat = "yyyy-MM-dd"
        if let codeName = UserDefaults.standard.string(forKey: "codeName") {
            print("This was the stored codeName: \(codeName)")
            fetchUserData(codeName: codeName)
        } else {
            print("no code name")
        }
    }
    
    func fetchUserData(codeName: String) {
        ref.child(codeName).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: Any] else {
                print("There is no data for this user")
                return
            }
            print(userDataDictionary)
            if let user = User(dictionary: userDataDictionary) {
                self.user = user
                
                if let lastDate =  self.df.date(from: user.lastDate) { //check if there is a streak still
                    if self.getDaysSince(day1: lastDate, day2: Date()) > 1 {
                        self.user?.dayStreak = 0
                    }
                }
                self.updateCollectionView?()
            }
        }
    }
    
    func fetchFriendData() {
        guard let user = user else { return }
        
    }
    
    func submit(codeName: String, user: User) {
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
        
        if let lastDate =  self.df.date(from: user.lastDate) { //check if there is a streak still
            if self.getDaysSince(day1: lastDate, day2: Date()) == 1 {
                self.user?.dayStreak += 1
                self.user?.lastDate = df.string(from: Date())
            } else if self.getDaysSince(day1: lastDate, day2: Date()) == 0 && user.lastDate == user.startDate {
                self.user?.dayStreak += 1
            }
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
