//
//  AcceptedUnit.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/8/24.
//

import Foundation

public enum AcceptedUnit: String, CaseIterable, Identifiable, Codable {
    case grams = "g"
    case ounces = "oz"
    case pounds = "lb"
    case milligrams = "mg"
    case milliliters = "ml"
    case count = "count"
    
    public var id: String { self.rawValue }
    
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
    
    var promptValue: String {
        switch self {
        case .grams:
            "3.5"
        case .ounces:
            "0.5"
        case .pounds:
            "0.25"
        case .milligrams:
            "2.5"
        case .milliliters:
            "5"
        case .count:
            "1"
        }
    }
}
