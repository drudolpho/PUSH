//
//  ProfileViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var userController: UserController?
    var audioController: AudioController?
    let soundSize: CGFloat = 20
    
    var chosenImage: UIImage? {
        didSet {
            guard let chosenImage = chosenImage, let userController = userController, let user = userController.user, let imageData = compressImage(name: user.codeName, image: chosenImage) else {
                errorChangingImageAlert()
                return
            }
            changeUserImage(imageData: imageData, image: chosenImage)
        }
    }
    
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var shadowView: UIImageView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.separatorColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        nameTF.borderStyle = .none
        greenView.layer.cornerRadius = 2
        shadowView.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("UpdateFriendView"), object: nil)
        
        guard let audioController = audioController else { return }
        let sound = UserDefaults.standard.integer(forKey: "Sound")
        if sound == 1 {
            audioController.audioType = .speak
            soundButton.setImage(UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: soundSize, weight: .medium, scale: .medium)), for: .normal)
        } else if sound == 2 {
            audioController.audioType = .none
            soundButton.setImage(UIImage(systemName: "speaker.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: soundSize, weight: .medium, scale: .medium)), for: .normal)
        } else {
            audioController.audioType = .sound
            soundButton.setImage(UIImage(systemName: "speaker.2.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: soundSize, weight: .medium, scale: .medium)), for: .normal)
        }
        soundButton.tintColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let userController = userController, let user = userController.user else { return }
        editImageButton.setImage(userController.images[user.imageID], for: .normal)
        editImageButton.layer.cornerRadius = (view.frame.height * 0.15)/2
        editImageButton.clipsToBounds = true
        friendTableView.backgroundColor = .clear
        friendTableView.reloadData()
        nameTF.text = user.name
        codeLabel.text = "#\(user.codeName.suffix(4))"
    }
    
    // MARK: - Methods
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.friendTableView.reloadData()
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
    
    // MARK: - Actions
    
    @IBAction func soundTapped(sender: UIButton) {
        guard let audioController = audioController else { return }
        let audioType = audioController.audioType
        if audioType == .sound {
            audioController.audioType = .speak
            soundButton.setImage(UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: soundSize, weight: .medium, scale: .medium)), for: .normal)
            UserDefaults.standard.set(1, forKey: "Sound")
        } else if audioType == .speak {
            audioController.audioType = .none
            soundButton.setImage(UIImage(systemName: "speaker.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: soundSize, weight: .medium, scale: .medium)), for: .normal)
            UserDefaults.standard.set(2, forKey: "Sound")
        } else if audioType == .none {
            audioController.audioType = .sound
            soundButton.setImage(UIImage(systemName: "speaker.2.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: soundSize, weight: .medium, scale: .medium)), for: .normal)
            UserDefaults.standard.set(0, forKey: "Sound")
        }
    }
    
    @IBAction func editImageTapped(sender: UIButton) {
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
}

// MARK: - Extensions

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
        guard let userController = userController else { return 0 }
        var cellCount = 6
        if userController.friends.count > 5 {
            cellCount = userController.friends.count + 1
        }
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userController = userController else { return UITableViewCell() }
        
        var cellCount = 6
        if userController.friends.count > 5 {
            cellCount = userController.friends.count + 1
        }
        
        if indexPath.row == cellCount - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as? AccountTableViewCell else { return UITableViewCell() }
            
            cell.userController = userController
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
            if userController.friends.count > 0 {
                if indexPath.row <= userController.friends.count - 1 {
                    cell.nameLabel.text = userController.friends[indexPath.row].name
                    cell.nameLabel.textColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1)
                    cell.friendImageView.image = userController.images[userController.friends[indexPath.row].codeName]
                    cell.nameLabel.isHidden = false
                    cell.removeButton.isHidden = false
                    cell.friendImageView.isHidden = false
                } else {
                    cell.nameLabel.isHidden = true
                    cell.removeButton.isHidden = true
                    cell.friendImageView.isHidden = true
                }
            } else {
                if indexPath.row == 0 {
                    cell.nameLabel.text = "You don't follow anyone"
                    cell.nameLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
                } else {
                    cell.nameLabel.isHidden = true
                }
                cell.removeButton.isHidden = true
                cell.friendImageView.isHidden = true
            }

            cell.index = indexPath.row
            cell.userController = userController
            cell.updateTableView = { () -> Void in
                self.friendTableView.reloadData()
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let userController = userController else { return tableView.frame.height / 7 }
        var cellCount = 6
        if userController.friends.count > 5 {
            cellCount = userController.friends.count + 1
        }
        
        if indexPath.row == cellCount - 1 {
            return 90
        } else {
            return tableView.frame.height / 7
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
