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
        if cellIndex == 0 {
            nameLabel.text = userController?.user?.name
            totalNumLabel.text = "\(userController?.user?.total ?? 0)"
            setsNumLabel.text = "\(userController?.user?.sets ?? 0)"
            avgNumLabel.text = "\(userController?.user?.avg ?? 0)"
            streakNumLabel.text = "\(userController?.user?.dayStreak.count ?? 0)"
            maxNumLabel.text = "\(userController?.user?.max ?? 0)"
            //configure with start date and formatter
            daysNumLabel.text = "0"
        } else {
            nameLabel.text = userController?.friends[cellIndex - 1].name
            totalNumLabel.text = "\(userController?.friends[cellIndex - 1].total ?? 0)"
            setsNumLabel.text = "\(userController?.friends[cellIndex - 1].sets ?? 0)"
            avgNumLabel.text = "\(userController?.friends[cellIndex - 1].avg ?? 0)"
            streakNumLabel.text = "\(userController?.friends[cellIndex - 1].dayStreak.count ?? 0)"
            maxNumLabel.text = "\(userController?.friends[cellIndex - 1].max ?? 0)"
            //configure with start date and formatter
            daysNumLabel.text = "0"
        }
    }
}
