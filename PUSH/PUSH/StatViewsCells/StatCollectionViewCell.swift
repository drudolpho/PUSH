//
//  StatCollectionViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class StatCollectionViewCell: UICollectionViewCell {
        override func awakeFromNib() {
           super.awakeFromNib()
           //custom logic goes here
            self.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
            self.layer.cornerRadius = 40
//            self.layer.shadowColor = UIColor.lightGray.cgColor
//            self.layer.shadowOpacity = 0.3
//            self.layer.shadowOffset = .zero
//            self.layer.shadowRadius = 10
            self.layer.masksToBounds = false
    //        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        }
}
