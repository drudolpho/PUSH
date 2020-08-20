//
//  StatCollectionViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class StatCollectionViewCell: UICollectionViewCell {
    
    var userController: UserController?
    var cellIndex = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var totalNumLabel: UILabel!
    @IBOutlet weak var setsNumLabel: UILabel!
    @IBOutlet weak var avgNumLabel: UILabel!
    @IBOutlet weak var streakNumLabel: UILabel!
    @IBOutlet weak var maxNumLabel: UILabel!
    @IBOutlet weak var daysNumLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        self.layer.cornerRadius = 40
        cellImageView.layer.cornerRadius = cellImageView.frame.size.width/2
        cellImageView.clipsToBounds = true
    }
    
    func updateViews() {
        guard let userController = self.userController, let user = userController.user else { return }
        if cellIndex == 0 {
            nameLabel.text = user.name
            cellImageView.image = userController.images[user.imageID]
            totalNumLabel.text = "\(user.total)"
            setsNumLabel.text = "\(user.sets)"
            avgNumLabel.text = "\(user.avg)"
            streakNumLabel.text = "\(user.dayStreak)"
            maxNumLabel.text = "\(user.max)"
            codeLabel.text = "#\(user.codeName.suffix(4))"
            if let dayOne = userController.df.date(from: user.startDate) {
                daysNumLabel.text = "\(userController.getDaysSince(day1: dayOne, day2: userController.date) + 1)"
            }
        } else {
            let friend = userController.friends[cellIndex - 1]
            nameLabel.text = friend.name
            cellImageView.image = userController.images[friend.imageID]
            totalNumLabel.text = "\(friend.total)"
            setsNumLabel.text = "\(friend.sets)"
            avgNumLabel.text = "\(friend.avg)"
            if let recentDate = userController.df.date(from: friend.lastDate) {
                if userController.getDaysSince(day1: recentDate, day2: userController.date) > 1 {
                    streakNumLabel.text = "0"
                } else {
                    streakNumLabel.text = "\(friend.dayStreak)"
                }
            }
            maxNumLabel.text = "\(userController.friends[cellIndex - 1].max)"
            codeLabel.text = "#\(userController.friends[cellIndex - 1].codeName.suffix(4))"
            if let dayOne = userController.df.date(from: userController.friends[cellIndex - 1].startDate) {
                daysNumLabel.text = "\(userController.getDaysSince(day1: dayOne, day2: userController.date) + 1)"
            }
        }
    }
}
