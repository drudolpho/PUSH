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
    
    func addGraph(withData: [Int], date: Date) {
        guard let activityGraph = activityGraph, let monthNum = date.monthNumber(), let dayNum = date.dayOfMonth() else { return }
        self.addSubview(activityGraph)
        
        let month2: String  = monthFor(number: monthNum)
        var month1: String {
            var monthName = "Dec"
            if monthNum != 1 {
                monthName = monthFor(number: monthNum - 1)
            }
            return monthName
        }
        
        var position: Int {
            var position = 2
            let lastRowCount = withData.count - 49
            
            if dayNum < lastRowCount {
                position = 4
            } else if dayNum < lastRowCount + 7 {
                position = 4
            } else if dayNum < lastRowCount + 14 {
                position = 2  
            } else {
                position = 1
            }

            return position
        }
        
        activityGraph.addWeeks(weekData: withData, position: position, month1: month1, month2: month2)
    }
    
    func monthFor(number: Int) -> String {
        switch number {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        default:
            return "Dec"
        }
    }
}
