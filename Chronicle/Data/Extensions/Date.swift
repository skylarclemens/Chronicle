//
//  Date.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/26/24.
//

import Foundation

extension Date {
    static func random(in range: ClosedRange<Date>) -> Date {
        let diff = range.upperBound.timeIntervalSince(range.lowerBound)
        let randomValue = Double.random(in: 0..<diff)
        return range.lowerBound.addingTimeInterval(randomValue)
    }
}
