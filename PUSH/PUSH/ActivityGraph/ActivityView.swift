//
//  ActivityView.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import UIKit

class ActivityView: UIView {
    
    var gap: Double {
        return (Double(frame.width) - 117) / 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func formatWeekData(data: [Int]) -> [[Int]] {
        var formattedData: [[Int]] = [[],[],[],[],[],[],[],[]]
        
        for i in 0...(data.count - 1) {
            switch i {
            case 0...6:
                formattedData[0].append(data[i])
            case 7...13:
                formattedData[1].append(data[i])
            case 14...20:
                formattedData[2].append(data[i])
            case 21...27:
                formattedData[3].append(data[i])
            case 28...34:
                formattedData[4].append(data[i])
            case 35...41:
                formattedData[5].append(data[i])
            case 42...48:
                formattedData[6].append(data[i])
            default:
                formattedData[7].append(data[i])
            }
        }
        
        return formattedData
    }
    
    func addWeeks(weekData: [Int], position: Int, month1: String, month2: String) {
        backgroundColor = .clear
        let mLabel = UILabel(frame: CGRect(x: gap/2, y: constants.dayWidth + constants.dayVgap, width: constants.dayLabelDimension, height: constants.dayLabelDimension))
        mLabel.text = "M"
        mLabel.font = UIFont.systemFont(ofSize: 10.0)
        mLabel.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        mLabel.textAlignment = .center
        self.addSubview(mLabel)
        
        let wLabel = UILabel(frame: CGRect(x: gap/2, y: (3 * constants.dayWidth) + (3 * constants.dayVgap), width: constants.dayLabelDimension, height: constants.dayLabelDimension))
        wLabel.text = "W"
        wLabel.font = UIFont.systemFont(ofSize: 10.0)
        wLabel.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        wLabel.textAlignment = .center
        self.addSubview(wLabel)
        
        let fLabel = UILabel(frame: CGRect(x: gap/2, y: (5 * constants.dayWidth) + (5 * constants.dayVgap), width: constants.dayLabelDimension, height: constants.dayLabelDimension))
        fLabel.text = "F"
        fLabel.font = UIFont.systemFont(ofSize: 10.0)
        fLabel.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        fLabel.textAlignment = .center
        self.addSubview(fLabel)
        
        let monthOneX: Double = constants.dayLabelDimension + (Double(position) * gap) + ((Double(position) - 1) * constants.dayWidth)
        
        let monthOne = UILabel(frame: CGRect(x: monthOneX, y: constants.weekHeight + constants.monthVgap/1.5, width: constants.dayLabelDimension * 3, height: constants.dayLabelDimension))
        monthOne.text = month1
        monthOne.font = UIFont.systemFont(ofSize: 10.0)
        monthOne.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        monthOne.textAlignment = .left
        self.addSubview(monthOne)
        
        let monthTwo = UILabel(frame: CGRect(x: monthOneX + ((4 * gap) + (4 * constants.dayWidth)), y: constants.weekHeight + constants.monthVgap/1.5, width: constants.dayLabelDimension * 3, height: constants.dayLabelDimension))
        monthTwo.text = month2
        monthTwo.font = UIFont.systemFont(ofSize: 10.0)
        monthTwo.textColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
        monthTwo.textAlignment = .left
        self.addSubview(monthTwo)
        
        var i = 1
        for data in formatWeekData(data: weekData) {
            let week = ColumnView(frame: CGRect(x: (Double(i) * gap) + (constants.dayWidth * Double(i)), y: 0, width: constants.dayWidth, height: constants.weekHeight))
            week.setColors(activity: data)
            self.addSubview(week)
            i += 1
        }
    }
}
