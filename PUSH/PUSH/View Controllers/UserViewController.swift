//
//  UserViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserViewController: UIViewController {
    
    var userController: UserController?
    
    var ref = Database.database().reference()

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
        submit(name: name)
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "user")
        dismiss(animated: true, completion: nil)
    }
    
    func submit(name: String) {
        ref.child(name).setValue(1) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            } else {
                print("Data saved successfully!")
            }
        }
    }
}
