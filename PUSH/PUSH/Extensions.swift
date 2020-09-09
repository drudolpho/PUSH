//
//  Extensions.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/20/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct ActivityConstants {
    var dayVgap: Double = 2
    var dayHeight: Double = 13
    var dayWidth: Double = 13
    var weekHeight: Double = 103
    var monthVgap: Double = 17
    var dayLabelDimension: Double = 12
    var graphHeight: Double = 135
    var totalDays: Int = 56
    var highPushupCount: Int = 50
}
let constants = ActivityConstants()

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func monthNumber() -> Int? {
        return Calendar.current.dateComponents([.month], from: self).month
    }
    
    func dayOfMonth() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
