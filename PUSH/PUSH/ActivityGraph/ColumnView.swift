//
//  ColumnView.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import UIKit

class ColumnView: UIView {

    var activity: [Int] = [0, 0, 0, 0, 0, 0, 0]
    var gap: Double = constants.dayVgap
    var width: Double = constants.dayWidth
    var height: Double = constants.dayHeight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setColors(activity: [Int]) {
        var newActivity = activity
        while newActivity.count < 7 {
            newActivity.append(3)
        }
        
        var colors: [UIColor] = []
        
        for day in newActivity {
            if day == 0 {
                colors.append(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1))
            } else if day == 1 {
                colors.append(UIColor(red: 60/255, green: 133/255, blue: 78/255, alpha: 1))
            } else if day == 2 {
                colors.append(UIColor(red: 58/255, green: 192/255, blue: 90/255, alpha: 1))
            } else if day == 3 {
                colors.append(UIColor.clear)
            }
        }
        setupView(correspondingActivityColors: colors)
    }
    
    private func setupView(correspondingActivityColors: [UIColor]) {
        self.backgroundColor = .clear
        let viewOne = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let viewTwo = UIView(frame: CGRect(x: 0, y: height + gap, width: width, height: height))
        let viewThree = UIView(frame: CGRect(x: 0, y: (2 * height) + (2 * gap), width: width, height: height))
        let viewFour = UIView(frame: CGRect(x: 0, y: (3 * height) + (3 * gap), width: width, height: height))
        let viewFive = UIView(frame: CGRect(x: 0, y: (4 * height) + (4 * gap), width: width, height: height))
        let viewSix = UIView(frame: CGRect(x: 0, y: (5 * height) + (5 * gap), width: width, height: height))
        let viewSeven = UIView(frame: CGRect(x: 0, y: (6 * height) + (6 * gap), width: width, height: height))
        
        viewOne.backgroundColor = correspondingActivityColors[0]
        viewTwo.backgroundColor = correspondingActivityColors[1]
        viewThree.backgroundColor = correspondingActivityColors[2]
        viewFour.backgroundColor = correspondingActivityColors[3]
        viewFive.backgroundColor = correspondingActivityColors[4]
        viewSix.backgroundColor = correspondingActivityColors[5]
        viewSeven.backgroundColor = correspondingActivityColors[6]
        
        let cornerRadius: CGFloat = 2
        viewOne.layer.cornerRadius = cornerRadius
        viewTwo.layer.cornerRadius = cornerRadius
        viewThree.layer.cornerRadius = cornerRadius
        viewFour.layer.cornerRadius = cornerRadius
        viewFive.layer.cornerRadius = cornerRadius
        viewSix.layer.cornerRadius = cornerRadius
        viewSeven.layer.cornerRadius = cornerRadius
        
        self.addSubview(viewOne)
        self.addSubview(viewTwo)
        self.addSubview(viewThree)
        self.addSubview(viewFour)
        self.addSubview(viewFive)
        self.addSubview(viewSix)
        self.addSubview(viewSeven)
    }
}

