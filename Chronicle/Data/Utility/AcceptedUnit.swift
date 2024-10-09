//
//  AcceptedUnit.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/8/24.
//

import Foundation

enum AcceptedUnit: String, CaseIterable, Identifiable, Codable {
    case grams = "g"
    case ounces = "oz"
    case pounds = "lb"
    case milligrams = "mg"
    case milliliters = "ml"
    case count = "count"
    
    var id: String { self.rawValue }
    
    var unitType: Unit {
        switch self {
        case .grams:
            UnitMass.grams
        case .ounces:
            UnitMass.ounces
        case .pounds:
            UnitMass.pounds
        case .milligrams:
            UnitMass.milligrams
        case .milliliters:
            UnitVolume.milliliters
        case .count:
            Unit(symbol: "count")
        }
    }
}
