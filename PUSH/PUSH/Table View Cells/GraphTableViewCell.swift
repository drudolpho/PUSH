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
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        activityLabel.textColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        dividerView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        helpButton.backgroundColor = .clear
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
            ,.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(string: "Help?",
                                                        attributes: yourAttributes)
        helpButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func helpButtonTapped(sender: UIButton) {
        
    }
    
    func addGraph(withData: [Int], date: Date) {
        guard let activityGraph = activityGraph, let monthNum = date.monthNumber(), let dayNum = date.dayOfMonth() else { return }
        activityGraph.tag = 100
        self.addSubview(activityGraph)
        
        activityGraph.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: activityGraph, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: activityLabel, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 33).isActive = true
        NSLayoutConstraint(item: activityGraph, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 15.0).isActive = true
//        NSLayoutConstraint(item: activityGraph, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 50.0).isActive = true
        
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
                position = 3
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
