//
//  ProfileViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var audioController: AudioController?
    var userController: UserController?
    
    var chosenImage: UIImage? {
        didSet {
            guard let chosenImage = chosenImage, let userController = userController, let user = userController.user, let imageData = compressImage(name: user.codeName, image: chosenImage) else {
                errorChangingImageAlert()
                return
            }
            changeUserImage(imageData: imageData, image: chosenImage)
        }
    }
    
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var friendTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        friendTableView.delegate = self
        friendTableView.dataSource = self
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let userController = userController, let user = userController.user else { return }
        editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
        editImageButton.clipsToBounds = true
        editImageButton.setImage(userController.images[user.imageID], for: .normal)
        friendTableView.backgroundColor = .clear
        friendTableView.reloadData()
    }
    
    private func setSpeakOn(bool: Bool) {
        guard let audioController = audioController else { return }
        if bool == false {
            audioController.speakOn = true
//            soundButton.setImage(UIImage(named: "speak"), for: .normal)
//            defaults.set(true, forKey: "sound")
        } else if bool == true {
            audioController.speakOn = false
//            soundButton.setImage(UIImage(named: "sound"), for: .normal)
//            defaults.set(false, forKey: "sound")
        }
    }
    
    @IBAction func resetDataTapped(sender: UIButton) {
        guard let userController = userController, let user = userController.user else { return }
        
        let alert = UIAlertController(title: "Are you sure you want to reset your data?", message: "You will keep your profile but your data will be reset to day one", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (action) in
            let resetUser: User = User(name: user.name, id: user.id, codeName: user.codeName, imageID: user.imageID, dayData: userController.dayDataCalc(), lastDate: userController.df.string(from: userController.date), startDate: userController.df.string(from: userController.date))
            
            userController.user = resetUser //updates Locally
            
            userController.updateUserDatatoServer(user: resetUser) { (error) in
                if let error = error {
                    print(error)
                }
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(resetUser) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "User")
                }
                UserDefaults.standard.set(0, forKey: "todaysPushups")
                NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
                self.tabBarController?.selectedIndex = 0
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func editImageTapped(sender: UIButton) {
        guard let userController = userController, let user = userController.user else { return }
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
    
    func errorChangingImageAlert() {
        let alert = UIAlertController(title: "There was an error changing your image", message: "Please check your connection and make sure the image is under 1.6 mb", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func changeUserImage(imageData: Data, image: UIImage) {
        guard let userController = userController, let user = userController.user else { return }
        
        //delete Image from server
        userController.deleteImage { (error) in
            if let _ = error {
                self.errorChangingImageAlert()
            } else {
                // add image to server
                userController.uploadImage(name: user.codeName, imageData: imageData) { (error) in
                    if let _ = error {
                        self.errorChangingImageAlert()
                    } else {
                        //delete/add from local images file
                        userController.saveImage(imageName: user.codeName, image: image)
                        
                        //update local dict
                        userController.images[user.codeName] = image
                        
                        //Change button last
                        self.editImageButton.setImage(image, for: .normal)
                        
                        NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
                    }
                }
            }
        }
    }
    
    func compressImage(name: String, image: UIImage) -> Data? {
        var compression: CGFloat = 1.0
        let maxCompression: CGFloat = 0.05
        let maxFileSize = 80000
        var imageData = image.jpegData(compressionQuality: compression)
        
        if imageData!.count > maxFileSize * 20 {
            print("Photo is too large")
            return nil
        }
        
        while (imageData!.count >= maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    func errorDeletingUserAlert() {
        let alert = UIAlertController(title: "Error deleting user", message: "We couldn't connect to the servers right now, please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
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
    
    
    @IBAction func deleteUserTapped(sender: UIButton) {
        guard let userController = userController else { return }
        
        let alert = UIAlertController(title: "Are you sure you want to delete your profile?", message: "Your will permanently lose all of your data", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            userController.deleteUserData { (error) in
                if let _ = error {
                    self.errorDeletingUserAlert()
                } else {
                    userController.deleteImage { (error) in
                        if let _ = error {
                            self.errorDeletingUserAlert()
                        } else {
                            let domain = Bundle.main.bundleIdentifier! //Gets rid of all userDefaults
                            UserDefaults.standard.removePersistentDomain(forName: domain)
                            UserDefaults.standard.synchronize()
                            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                            
                            userController.reset()
                            NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    @IBAction func soundTapped(sender: UIButton) {
        guard let audioController = audioController else { return }
        setSpeakOn(bool: audioController.speakOn)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
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

extension ProfileViewController: UINavigationControllerDelegate {

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController?.friends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell, let userController = userController else { return UITableViewCell() }
        cell.nameLabel.text = userController.friends[indexPath.row].name
        cell.friendImageView.image = userController.images[userController.friends[indexPath.row].codeName]
        cell.index = indexPath.row
        cell.userController = userController
        cell.updateTableView = { () -> Void in
            self.friendTableView.reloadData()
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
