//
//  StatTableViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/24/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class StatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statOneNameLabel: UILabel!
    @IBOutlet weak var statOneValueLabel: UILabel!
    @IBOutlet weak var statTwoNameLabel: UILabel!
    @IBOutlet weak var statTwoValueLabel: UILabel!
    @IBOutlet weak var statThreeNameLabel: UILabel!
    @IBOutlet weak var statThreeValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
}
