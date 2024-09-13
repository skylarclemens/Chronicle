//
//  Double.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import Foundation

extension Double {
    func round(toNearest: Double) -> Double {
        let n = 1/toNearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
}
