//
//  SplashViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/13/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    let userController = UserController()

    override func viewDidLoad() {
        super.viewDidLoad()
        login()
//        simLogin() // for using a simulator
    }
    
    func login() {
        userController.getUserData()
        
        self.performSegue(withIdentifier: "MainSegue", sender: nil)
        
//        if let codeName = UserDefaults.standard.string(forKey: "codeName") {
//            print("This was the stored codeName: \(codeName)")
//            userController.fetchUserData(codeName: codeName) { (user) in
//                if user == false {
//                    UserDefaults.standard.set(nil, forKey: "codeName")
//                }
//                self.performSegue(withIdentifier: "MainSegue", sender: nil)
//            }
//        } else {
//            performSegue(withIdentifier: "MainSegue", sender: nil)
//        }
    }
    
//    func simLogin() { // Use this when using a simulator
//        userController.fetchUserData(codeName: "DennisB2D6") { (user) in
//            if user == false {
//                UserDefaults.standard.set(nil, forKey: "codeName")
//            }
//            self.performSegue(withIdentifier: "MainSegue", sender: nil)
//        }
//    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            if let tabBar = segue.destination as? UITabBarController {
                let mainVC = tabBar.viewControllers?[0] as! MainViewController
                mainVC.userController = userController
                let pushVC = tabBar.viewControllers?[1] as! PushViewController
                pushVC.userController = userController
                pushVC.delegate = mainVC as PushViewControllerDelegate
                let profileVC = tabBar.viewControllers?[2] as! ProfileViewController
                profileVC.userController = userController
            }
        }
    }
}
