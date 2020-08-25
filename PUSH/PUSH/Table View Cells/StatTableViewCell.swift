//
//  StatTableViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/24/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class StatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statNameLabel: UILabel!
    @IBOutlet weak var statValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
}
