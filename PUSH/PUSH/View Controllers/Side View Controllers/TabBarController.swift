//
//  TabBarController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        tabBar.isTranslucent = false
        
        tabBar.tintColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        tabBar.clipsToBounds = true
    }
}
