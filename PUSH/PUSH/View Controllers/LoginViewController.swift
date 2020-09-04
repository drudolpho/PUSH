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
    
    var chosenImage: UIImage? {
        didSet {
            guard let chosenImage = chosenImage else { return }

            imageViewButton.setImage(chosenImage, for: .normal)
        }
    }

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var imageViewButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        self.view.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        nameTF.layer.cornerRadius = 10
        nameTF.clipsToBounds = true
        imageViewButton.imageView?.layer.cornerRadius = imageViewButton.frame.size.width / 2.0
        doneButton.layer.cornerRadius = 25
        
        if let _ = userController?.user { //prevents user from swiping to dismiss if no user is set
            self.isModalInPresentation = false
        } else {
            self.isModalInPresentation = true
        }
        self.hideKeyboardWhenTappedAround() 
    }

    
    // MARK: - Alerts
    
    private func imageAlert() {
        let imageAlert = UIAlertController(title: "Please choose a photo", message: nil, preferredStyle: .actionSheet)
        imageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.presentImagePickerController(type: 0)
        }))
        imageAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.presentImagePickerController(type: 1)
        }))
        imageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(imageAlert, animated: true)
    }
    
    private func badNameAlert() {
        let badNameAlert = UIAlertController(title: "Invalid name", message: "Please create an alphanumeric name between 3 and 8 characters", preferredStyle: .alert)
        badNameAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    private func bigImageAlert() {
        let bigImageAlert = UIAlertController(title: "Image is too large", message: "Please choose an image under 1.6 mb", preferredStyle: .alert)
        bigImageAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    // MARK: - Actions
    
    @IBAction func imageViewButtonTapped(_ sender: UIButton) {
        imageAlert()
    }
    
    @IBAction func readyButton(_ sender: UIButton) {
        guard let userController = userController, let name = nameTF.text, !name.isEmpty, name.count < 9, name.count > 2 else {
            badNameAlert()
            return
        }
        guard let image = chosenImage else {
            imageAlert()
            return
        }
        
        let uuid = UUID()
        let uuidString = uuid.uuidString
        let codeName = name + String(uuidString[0]) + String(uuidString[1]) + String(uuidString[2]) + String(uuidString[3])
        let noSpacesCodeName = String(codeName.filter { !" \n\t\r".contains($0) })
        guard noSpacesCodeName.isAlphanumeric else {
            badNameAlert()
            return
        }
        
        guard let imageData = userController.compressAddImage(name: noSpacesCodeName, image: image) else {
            bigImageAlert()
            return
        }
        
        let user = User(name: name, id: uuidString, codeName: noSpacesCodeName, imageID: noSpacesCodeName, dayData: dayDataCalc(), lastDate: userController.df.string(from: userController.date), startDate: userController.df.string(from: userController.date))
        
        userController.user = user
        userController.submitUserInfo(codeName: noSpacesCodeName, user: user)
        userController.uploadImage(name: noSpacesCodeName, imageData: imageData)
        updateCollectionView?()
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    private func presentImagePickerController(type: Int) {
        let imagePicker = UIImagePickerController()
        
        if type == 0 {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("The photo library is not available")
                return
            }
            
            imagePicker.sourceType = .photoLibrary
        } else if type == 1 {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("The camera is not available")
                return
            }
            
            imagePicker.sourceType = .camera
        } else {
            return
        }
        
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dayDataCalc() -> [Int] {
        var dayData = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        guard let day = userController?.date.dayNumberOfWeek() else { return dayData }
        
        for _ in 1...day {
            dayData.append(0)
        }
        
        return dayData
    }
}

extension LoginViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[.originalImage] as? UIImage {
            chosenImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UINavigationControllerDelegate {

}
