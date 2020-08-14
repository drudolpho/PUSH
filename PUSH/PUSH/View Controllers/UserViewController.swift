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
    var updateCollectionView: (() -> Void)?

    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = userController?.user { //prevents user from swiping to dismiss if no user is set
            self.isModalInPresentation = false
        } else {
            self.isModalInPresentation = true
        }
    }
    
    @IBAction func readyButton(_ sender: UIButton) {
        guard let userController = userController, let name = nameTF.text, !name.isEmpty  else { return }
        
        let uuid = UUID()
        let uuidString = uuid.uuidString
        let codeName = name + String(uuidString[0]) + String(uuidString[1]) + String(uuidString[2]) + String(uuidString[3])
        let noSpacesCodeName = String(codeName.filter { !" \n\t\r".contains($0) })
        guard noSpacesCodeName.isAlphanumeric else {
            //alert
            return
        }
        let user = User(name: name, id: uuidString, codeName: noSpacesCodeName, lastDate: userController.df.string(from: userController.date), startDate: userController.df.string(from: userController.date))
        
        userController.user = user
        userController.submitUserInfo(codeName: noSpacesCodeName, user: user)
        updateCollectionView?()
        
        dismiss(animated: true, completion: nil)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
