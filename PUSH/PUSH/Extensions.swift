//
//  Extensions.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/20/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation

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
}
let constants = ActivityConstants()
