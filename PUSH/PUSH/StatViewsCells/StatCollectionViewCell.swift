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
           //custom logic goes here
            self.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
            self.layer.cornerRadius = 40
//            self.layer.shadowColor = UIColor.lightGray.cgColor
//            self.layer.shadowOpacity = 0.3
//            self.layer.shadowOffset = .zero
//            self.layer.shadowRadius = 10
            cellImageView.layer.cornerRadius = cellImageView.frame.size.width/2
            cellImageView.clipsToBounds = true
    //        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        }
    func updateViews() {
        guard let userController = self.userController, let user = userController.user else { return }
        if cellIndex == 0 {
            nameLabel.text = user.name
            totalNumLabel.text = "\(user.total)"
            setsNumLabel.text = "\(user.sets)"
            avgNumLabel.text = "\(user.avg)"
            streakNumLabel.text = "\(user.dayStreak)"
            maxNumLabel.text = "\(user.max)"
            codeLabel.text = "#\(user.codeName.suffix(4))"
            if let dayOne = userController.df.date(from: user.startDate) {
                daysNumLabel.text = "\(userController.getDaysSince(day1: dayOne, day2: Date()) + 1)"
            }
        } else {
            nameLabel.text = userController.friends[cellIndex - 1].name
            totalNumLabel.text = "\(userController.friends[cellIndex - 1].total)"
            setsNumLabel.text = "\(userController.friends[cellIndex - 1].sets)"
            avgNumLabel.text = "\(userController.friends[cellIndex - 1].avg)"
            if let recentDate = userController.df.date(from: userController.friends[cellIndex - 1].lastDate) {
                if userController.getDaysSince(day1: recentDate, day2: Date()) > 1 {
                    streakNumLabel.text = "0"
                } else {
                    streakNumLabel.text = "\(userController.friends[cellIndex - 1].dayStreak)"
                }
            }
            maxNumLabel.text = "\(userController.friends[cellIndex - 1].max)"
            codeLabel.text = "#\(userController.friends[cellIndex - 1].codeName.suffix(4))"
            if let dayOne = userController.df.date(from: userController.friends[cellIndex - 1].startDate) {
                daysNumLabel.text = "\(userController.getDaysSince(day1: dayOne, day2: Date()) + 1)"
            }
        }
    }
}
