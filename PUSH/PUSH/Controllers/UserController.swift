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
    var storageRef = Storage.storage().reference()
    let df = DateFormatter()
    var date: Date {
        Date()
    }
    var isFetching = false
//    for testing future dates
//    var date: Date {
//        var dateComponents = DateComponents()
//        dateComponents.year = 2020
//        dateComponents.month = 9
//        dateComponents.day = 11
//        dateComponents.hour = 8
//        dateComponents.minute = 33
//
//        let userCalendar = Calendar.current // user calendar
//        return userCalendar.date(from: dateComponents)!
//    }
    
    init() {
        df.dateFormat = "yyyy-MM-dd"
    }
    
    
    // MARK: - User CRUD Methods
    
    func getUserData() {
        if let savedUser = UserDefaults.standard.object(forKey: "User") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUser) {

                if let lastDate =  self.df.date(from: loadedUser.lastDate) { //check if there is a streak still
                    let daysSince = self.getDaysSince(day1: lastDate, day2: self.date)
                    if daysSince > 0 {
                        for _ in 1...daysSince {
                            self.appendADayData(user: loadedUser, value: 0)
                        }
                    }
                    if daysSince > 1 {
                        loadedUser.dayStreak = 0
                    }
                }
                self.user = loadedUser
                
                //get users image
                let usersImage = loadImageFromDiskWith(fileName: loadedUser.codeName)
                images[loadedUser.codeName] = usersImage
                
                self.isFetching = true
                self.fetchAllFriendData {
                    self.fetchPhotosFromStorage() {
                        self.isFetching = false
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
                            NotificationCenter.default.post(name: Notification.Name("UpdateFriendView"), object: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func deleteUserData(completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        ref.child(user.codeName).removeValue { (error, reference) in
            if let error = error {
                print(error)
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func submitUserInfo(codeName: String, user: User, completion: @escaping (Error?) -> Void) {
        ref.child(codeName).setValue(user.dictionaryRepresentation) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func updateUserDatatoServer(user: User) {
        //update server with new user data
        ref.child(user.codeName).updateChildValues(user.dictionaryRepresentation) { (error, ref) in
            if let error = error {
                print("data not saved correctly \(error)")
            }
        }
    }
    
    func newSet(user: User, reps: Int) -> User {
        user.sets += 1
        user.total += reps
        user.avg = user.total / user.sets
        if reps > user.max {
            user.max = reps
        }
        
        if daysSinceLastDate() == 1 { //add to streak
            self.user?.dayStreak += 1
            self.user?.lastDate = df.string(from: date)
            if reps >= constants.highPushupCount {
                user.dayData[(user.dayData.count - 1)] = 2
            } else {
                user.dayData[(user.dayData.count - 1)] = 1
            }
            UserDefaults.standard.set(reps, forKey: "todaysPushups")
        } else if daysSinceLastDate() == 0 && user.lastDate == user.startDate { //users first day
            self.user?.dayStreak += 1
            let todaysCount = UserDefaults.standard.integer(forKey: "todaysPushups")
            let newCount = reps + todaysCount
            if newCount >= constants.highPushupCount {
                user.dayData[(user.dayData.count - 1)] = 2
            } else {
                user.dayData[(user.dayData.count - 1)] = 1
            }
            UserDefaults.standard.set(newCount, forKey: "todaysPushups")
        } else if daysSinceLastDate() == 0 { //new set same day
            let todaysCount = UserDefaults.standard.integer(forKey: "todaysPushups")
            let newCount = reps + todaysCount
            if newCount >= constants.highPushupCount {
                user.dayData[(user.dayData.count - 1)] = 2
            } else {
                user.dayData[(user.dayData.count - 1)] = 1
            }
            UserDefaults.standard.set(newCount, forKey: "todaysPushups")
        } else { // streak ended
            self.user?.dayStreak = 1
            self.user?.lastDate = df.string(from: date)
            if reps >= constants.highPushupCount {
                user.dayData[(user.dayData.count - 1)] = 2
            } else {
                user.dayData[(user.dayData.count - 1)] = 1
            }
            UserDefaults.standard.set(reps, forKey: "todaysPushups")
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "User")
        }
        
        return user
    }

    
    // MARK: - Friend CRUD Methods
    
    func fetchAllFriendData(completion: @escaping () -> Void) {
        var friends: [String] = UserDefaults.standard.stringArray(forKey: "friends") ?? []
        var codesToRemove: [Int] = []
        var friendIndex = 0
        
        let friendGroup = DispatchGroup()
        
        for friend in friends {
            friendGroup.enter()
            ref.child(friend).observeSingleEvent(of: .value) { (snapshot) in
                if let userDataDictionary = snapshot.value as? [String: Any] {
                    if let user = User(dictionary: userDataDictionary) {
                        if let lastDate =  self.df.date(from: user.lastDate) { //check if there is a streak still
                            let daysSince = self.getDaysSince(day1: lastDate, day2: self.date)
                            if daysSince > 0 {
                                for _ in 1...daysSince {
                                    self.appendADayData(user: user, value: 0)
                                }
                            }
                            if daysSince > 1 {
                                user.dayStreak = 0
                            }
                        }
                        self.friends.append(user)
                    } else {
                        codesToRemove.append(friendIndex)
                    }
                } else {
                    codesToRemove.append(friendIndex)
                }
                friendIndex += 1
                friendGroup.leave()
            }
        }
        
        friendGroup.notify(queue: .main) {
            for index in codesToRemove {
                friends.remove(at: index)
                UserDefaults.standard.set(friends, forKey: "friends")
            }
            completion()
        }
    }
    
    func findFriendData(codeName: String, completion: @escaping (Bool) -> Void) {
        ref.child(codeName).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            if let user = User(dictionary: userDataDictionary) {
                if let lastDate =  self.df.date(from: user.lastDate) { //check if there is a streak still
                    let daysSince = self.getDaysSince(day1: lastDate, day2: self.date)
                    if daysSince > 0 {
                        for _ in 1...daysSince {
                            self.appendADayData(user: user, value: 0)
                        }
                    }
                    if daysSince > 1 {
                        user.dayStreak = 0
                    }
                }
                
                self.friends.append(user)
                
                var friends: [String] = UserDefaults.standard.stringArray(forKey: "friends") ?? []
                friends.append(codeName)
                UserDefaults.standard.set(friends, forKey: "friends")
                //fetch photo
                self.fetchPhoto(photoID: user.imageID) {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func updateFriendData() {
        let friendGroup = DispatchGroup()
        
        var friendIndex = 0
        for friend in friends {
            friendGroup.enter()
            ref.child(friend.codeName).observeSingleEvent(of: .value) { (snapshot) in
                if let userDataDictionary = snapshot.value as? [String: Any] {
                    if let user = User(dictionary: userDataDictionary) {
                        if let lastDate =  self.df.date(from: user.lastDate) { //check if there is a streak still
                            let daysSince = self.getDaysSince(day1: lastDate, day2: self.date)
                            if daysSince > 0 {
                                for _ in 1...daysSince {
                                    self.appendADayData(user: user, value: 0)
                                }
                            }
                            if daysSince > 1 {
                                user.dayStreak = 0
                            }
                        }
                        //update the friend
                        if self.friends[friendIndex].codeName == user.codeName {
                            self.friends[friendIndex] = user
                        }
                        friendIndex += 1
                    }
                }
                friendGroup.leave()
            }
        }
        
        friendGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("UpdateFriendView"), object: nil)
            }
        }
    }
    
    
    // MARK: - Image Methods
    
    func compressAddImage(name: String, image: UIImage) -> Data? {
        var compression: CGFloat = 1.0
        let maxCompression: CGFloat = 100
        let maxFileSize = 80000
        var imageData = image.jpegData(compressionQuality: compression)
        
        if imageData!.count > maxFileSize * 60 {
            print("Photo is too large")
            return nil
        }
        
        while (imageData!.count >= maxFileSize) && (compression < maxCompression) {
            if compression < 10 {
                compression += 1
            } else {
                compression += 10
            }
            imageData = image.jpegData(compressionQuality: 1/compression)
        }
        
        images[name] = image
        return imageData
    }
    
    func uploadImage(name: String, imageData: Data, completion: @escaping (Error?) -> Void) {
        let imageRef = storageRef.child(name)
        _ = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error saving image to storage \(error)")
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteImage(completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        let desertRef = storageRef.child(user.imageID)
        desertRef.delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchPhotosFromStorage(completion: @escaping () -> Void) {
        var photoIDs: [String] = []
        for friend in friends {
            photoIDs.append(friend.imageID)
        }
        
        let photoGroup = DispatchGroup()
        
        for id in photoIDs {
            photoGroup.enter()
            let photoRef = storageRef.child(id)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error loading images \(error)")
                    let image = UIImage(named: "chooseImage")
                    self.images[id] = image
                }
                if let data = data {
                    let image = UIImage(data: data)
                    self.images[id] = image
                } else {
                    let image = UIImage(named: "chooseImage")
                    self.images[id] = image
                }
                photoGroup.leave()
            }
        }
        
        photoGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func fetchPhoto(photoID: String, completion: @escaping () -> Void) { //For fetching photo in friend search
        let photoRef = storageRef.child(photoID)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error loading images \(error)")
                let image = UIImage(named: "chooseImage")
                self.images[photoID] = image
            }
            if let data = data {
                let image = UIImage(data: data)
                self.images[photoID] = image
            } else {
                let image = UIImage(named: "chooseImage")
                self.images[photoID] = image
            }
            completion()
        }
    }
    
    func saveImage(imageName: String, image: UIImage) { //saves image to local file
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage {
      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                return image
            } else {
                return UIImage(contentsOfFile: "chooseImage")!
            }
        }
        return UIImage(contentsOfFile: "chooseImage")!
    }
    
    // MARK: - Helper Methods
    
    func reset() {
        user = nil
        friends = []
        images = [:]
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
    }
    
    func appendADayData(user: User, value: Int) {
        switch user.dayData.count {
        case constants.totalDays:
            user.dayData.append(value)
            for i in 0...6 {
                user.dayData.remove(at: i)
            }
        default:
            user.dayData.append(value)
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
    
    func dayDataCalc() -> [Int] {
        var dayData = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        guard let day = self.date.dayNumberOfWeek() else { return dayData }
        
        for _ in 1...day {
            dayData.append(0)
        }
        
        return dayData
    }
}
