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
    }
    
    func login() {
        if let codeName = UserDefaults.standard.string(forKey: "codeName") {
            print("This was the stored codeName: \(codeName)")
            userController.fetchUserData(codeName: codeName) { (user) in
                if user == false {
                    UserDefaults.standard.set(nil, forKey: "codeName")
                }
                self.performSegue(withIdentifier: "MainSegue", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "MainSegue", sender: nil)
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            if let viewController = segue.destination as? MainViewController {
                viewController.userController = userController
            }
        }
    }
}
