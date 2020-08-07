//
//  UserViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var userController: UserController?

    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = userController?.user {
            self.isModalInPresentation = false
        } else {
            self.isModalInPresentation = true
        }
    }
    
    @IBAction func readyButton(_ sender: UIButton) {
        guard let userController = userController, let name = nameTF.text, !name.isEmpty  else { return }
        
        let uuid = UUID()
        let user = User(name: name, id: uuid, codeName: "", imageID: "")
        
        userController.user = user
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "user")
        dismiss(animated: true, completion: nil)
    }
}
