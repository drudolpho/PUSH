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
        tabBar.barTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        tabBar.isTranslucent = false
        
        tabBar.tintColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        setTabBarItems()
    }
    
    func setTabBarItems(){

//          let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
//          myTabBarItem1.image = UIImage(named: "TrackerDark")
//          myTabBarItem1.selectedImage = UIImage(named: "TrackerLight")
//          myTabBarItem1.title = "Tracker"
//          myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//
//          let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
//          myTabBarItem2.image = UIImage(named: "CounterDark")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//          myTabBarItem2.selectedImage = UIImage(named: "CounterLight")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//          myTabBarItem2.title = "Counter"
//          myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//
//          let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
//          myTabBarItem3.image = UIImage(named: "SettingsDark")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//          myTabBarItem3.selectedImage = UIImage(named: "SettingsLight")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//          myTabBarItem3.title = "Settings"
//          myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
     }
}
