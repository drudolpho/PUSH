//
//  FriendTableViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 9/10/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    var userController: UserController?
    var updateTableView: (() -> Void)?
    var index: Int?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.textColor = .white
        friendImageView.layer.cornerRadius = friendImageView.frame.size.width/1.7
        friendImageView.clipsToBounds = true
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        guard let userController = userController, let updateTableView = updateTableView, let index = index else { return }
        let alert = UIAlertController(title: "Are you sure you want to stop following \(userController.friends[index].name)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let friendCodetoRemove = userController.friends[index].codeName
            
            var friends: [String] = UserDefaults.standard.stringArray(forKey: "friends") ?? []
            var friendIndex = 0
            var friendRemoved = false
            for friendCode in friends {
                if friendCode == friendCodetoRemove {
                    friends.remove(at: friendIndex)
                    userController.friends.remove(at: index)
                    friendRemoved = true
                }
                friendIndex += 1
            }
            UserDefaults.standard.set(friends, forKey: "friends")
            
            if friendRemoved == false {
                let alert = UIAlertController(title: "We had trouble removing this friend", message: "Check your connection and please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.parentViewController?.present(alert, animated: true, completion: nil)
            } else {
                updateTableView()
                NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
}
