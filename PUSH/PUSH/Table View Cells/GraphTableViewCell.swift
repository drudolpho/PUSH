//
//  GraphTableViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class GraphTableViewCell: UITableViewCell {
    
    var activityGraph: ActivityView?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    
    func addGraph(withData: [Int], position: Int, month1: String, month2: String) {
        guard let activityGraph = activityGraph else { return }
        self.addSubview(activityGraph)
        activityGraph.addWeeks(weekData: withData, position: position, month1: month1, month2: month2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
