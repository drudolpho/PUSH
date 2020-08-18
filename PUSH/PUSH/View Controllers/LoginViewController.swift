//
//  LoginViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var userController: UserController?
    var updateCollectionView: (() -> Void)?

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var imageViewButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        self.view.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        nameTF.layer.cornerRadius = 10
        nameTF.clipsToBounds = true
        doneButton.layer.cornerRadius = 25
        if let _ = userController?.user { //prevents user from swiping to dismiss if no user is set
            self.isModalInPresentation = false
        } else {
            self.isModalInPresentation = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func imageViewButtonTapped(_ sender: UIButton) {
        //go to photo library
    }
    
    @IBAction func imageOneTapped(_ sender: UIButton) {
        imageViewButton.setImage(UIImage(named: "Tiger"), for: .normal)
    }
    
    @IBAction func imageTwoTapped(_ sender: UIButton) {
        imageViewButton.setImage(UIImage(named: "Gorilla"), for: .normal)
    }
    
    @IBAction func imageThreeTapped(_ sender: UIButton) {
        imageViewButton.setImage(UIImage(named: "Lizard"), for: .normal)
    }
    
    @IBAction func imageFourTapped(_ sender: UIButton) {
        //go to photo library
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
