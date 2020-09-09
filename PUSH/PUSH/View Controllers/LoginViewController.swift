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
            addPhotosButton.setImage(chosenImage, for: .normal)
        }
    }

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var helpLabel1: UILabel!
    @IBOutlet weak var helpLabel3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nameTF.delegate = self
        self.view.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
//        nameTF.clipsToBounds = true
        doneButton.layer.cornerRadius = 25
        greenView.layer.cornerRadius = 2
        fullView.layer.cornerRadius = 40
        fullView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        
        addPhotosButton.layer.cornerRadius = addPhotosButton.frame.size.width/2
        addPhotosButton.clipsToBounds = true
        
        nameTF.borderStyle = .none
        nameTF.attributedPlaceholder = NSAttributedString(string: "YourName",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)])
        helpLabel1.textColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
        helpLabel3.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        cardView.layer.cornerRadius = 35
        cardView.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.8).cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowRadius = 10
        
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = addPhotosButton.frame.size.width/2
        shadowView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        shadowView.layer.shadowColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1).cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 0
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: addPhotosButton.frame.size.width/2).cgPath
        
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
        let badNameAlert = UIAlertController(title: "Invalid name", message: "Please create an alphanumeric name between 4 and 12 characters", preferredStyle: .alert)
        badNameAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    private func bigImageAlert() {
        let bigImageAlert = UIAlertController(title: "Image is too large", message: "Please choose an image under 1.6 mb", preferredStyle: .alert)
        bigImageAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }

    
    // MARK: - Actions
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        imageAlert()
    }
    
    @IBAction func readyButton(_ sender: UIButton) {
        guard let userController = userController, let name = nameTF.text, !name.isEmpty, name.count < 13, name.count > 3 else {
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
        
        //These need to be successful in order to create user
        userController.submitUserInfo(codeName: noSpacesCodeName, user: user) { (error) in
            if let _ = error {
                self.presentCouldntSaveAlert()
            } else {
                userController.uploadImage(name: noSpacesCodeName, imageData: imageData) { (error) in
                    if let _ = error {
                        self.presentCouldntSaveAlert()
                    } else {
                        userController.saveImage(imageName: noSpacesCodeName, image: image)
                        self.updateCollectionView?()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if nameTF.isFirstResponder == true {
            nameTF.placeholder = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 13
    }
    
    func presentCouldntSaveAlert() {
        let alert = UIAlertController(title: "Error creating profile", message: "We could'nt reach our servers at this time, please try again with better connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
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
