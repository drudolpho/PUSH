//
//  AccountTableViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 9/11/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    var userController: UserController?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        deleteButton.layer.cornerRadius = 15
        resetButton.layer.cornerRadius = 15
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
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
                            self.parentViewController?.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        guard let userController = userController, let user = userController.user else { return }
        
        let alert = UIAlertController(title: "Are you sure you want to reset your data?", message: "You will keep your profile but your data will be reset to day one", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (action) in
            let resetUser: User = User(name: user.name, id: user.id, codeName: user.codeName, imageID: user.imageID, dayData: userController.dayDataCalc(), lastDate: userController.df.string(from: userController.date), startDate: userController.df.string(from: userController.date))
            
            userController.user = resetUser //updates Locally
            
            userController.updateUserDatatoServer(user: resetUser)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(resetUser) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "User")
            }
            UserDefaults.standard.set(0, forKey: "todaysPushups")
            NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
            self.parentViewController?.tabBarController?.selectedIndex = 1
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    func errorDeletingUserAlert() {
        let alert = UIAlertController(title: "Error deleting user", message: "We couldn't connect to the servers right now, please try again later with better connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
}
