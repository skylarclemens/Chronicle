//
//  DefaultUnits.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/8/24.
//

import Foundation

struct DefaultUnits: Codable {
    var edible: AcceptedUnit = .milligrams
    var flower: AcceptedUnit = .grams
    var preroll: AcceptedUnit = .grams
    var tincture: AcceptedUnit = .milliliters
    var concentrate: AcceptedUnit = .grams
    var topical: AcceptedUnit = .milligrams
    var pill: AcceptedUnit = .milligrams
    var other: AcceptedUnit = .grams
    
    subscript(itemType: ItemType) -> AcceptedUnit {
        get {
            switch itemType {
            case .edible:
                edible
            case .flower:
                flower
            case .preroll:
                preroll
            case .tincture:
                tincture
            case .concentrate:
                concentrate
            case .topical:
                topical
            case .pill:
                pill
            case .other:
                other
            }
        }
        set {
            switch itemType {
            case .edible:
                edible = newValue
            case .flower:
                flower = newValue
            case .preroll:
                preroll = newValue
            case .tincture:
                tincture = newValue
            case .concentrate:
                concentrate = newValue
            case .topical:
                topical = newValue
            case .pill:
                pill = newValue
            case .other:
                other = newValue
            }
        }
    }
}
