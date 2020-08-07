//
//  UserController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation

class UserController {
    var user: User?
    var friends: [User] = []
    
    init() {
        if let data = UserDefaults.standard.value(forKey: "user") as? Data {
            guard let user = try? PropertyListDecoder().decode(User.self, from: data) else { return }
            self.user = user
        }
    }
}
