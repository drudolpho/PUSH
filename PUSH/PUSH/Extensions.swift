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
