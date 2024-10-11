//
//  DefaultUnits.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/8/24.
//

import Foundation

struct DefaultUnits: Codable {
    var edible: ItemUnits = ItemUnits(amount: .count, dosage: .milligrams)
    var flower: ItemUnits = ItemUnits(amount: .grams, dosage: .grams)
    var preroll: ItemUnits = ItemUnits(amount: .grams, dosage: .grams)
    var tincture: ItemUnits = ItemUnits(amount: .milliliters, dosage: .milliliters)
    var concentrate: ItemUnits = ItemUnits(amount: .grams, dosage: .grams)
    var topical: ItemUnits = ItemUnits(amount: .milliliters, dosage: .milliliters)
    var pill: ItemUnits = ItemUnits(amount: .count, dosage: .milligrams)
    var other: ItemUnits = ItemUnits(amount: .grams, dosage: .milligrams)
    
    subscript(itemType: ItemType) -> ItemUnits {
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

public struct ItemUnits: Codable {
    var amount: AcceptedUnit
    var dosage: AcceptedUnit
}
