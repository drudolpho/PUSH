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
    let audioController = AudioController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    func login() {
        userController.getUserData()
        
        self.performSegue(withIdentifier: "MainSegue", sender: nil)
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            if let tabBar = segue.destination as? UITabBarController {
                let mainVC = tabBar.viewControllers?[1] as! StatViewController
                mainVC.userController = userController
                let pushVC = tabBar.viewControllers?[0] as! PushViewController
                pushVC.userController = userController
                pushVC.audioController = audioController
                pushVC.delegate = mainVC as PushViewControllerDelegate
                let profileVC = tabBar.viewControllers?[2] as! ProfileViewController
                profileVC.userController = userController
                profileVC.audioController = audioController
            }
        }
    }
}
