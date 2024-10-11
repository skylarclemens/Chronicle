//
//  UnitManager.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/8/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class UnitManager {
    static let shared = UnitManager()
    @ObservationIgnored var defaultUnits: DefaultUnits {
        get {
            access(keyPath: \.defaultUnits)
            if let savedDefaultUnitsData = UserDefaults.standard.data(forKey: "defaultUnits"),
               let decoded = try? JSONDecoder().decode(DefaultUnits.self, from: savedDefaultUnitsData) {
                return decoded
            }
            return DefaultUnits()
        }
        set {
            withMutation(keyPath: \.defaultUnits) {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: "defaultUnits")
                }
            }
        }
    }
    
    private init() {}
    
    func getAmountUnit(for itemType: ItemType) -> AcceptedUnit {
        defaultUnits[itemType].amount
    }
    
    func getDosageUnit(for itemType: ItemType) -> AcceptedUnit {
        defaultUnits[itemType].dosage
    }
    
    func setAmountUnit(_ unit: AcceptedUnit, for itemType: ItemType) {
        var itemUnits = defaultUnits[itemType]
        itemUnits.amount = unit
        defaultUnits[itemType] = itemUnits
    }
    
    func setDosageUnit(_ unit: AcceptedUnit, for itemType: ItemType) {
        var itemUnits = defaultUnits[itemType]
        itemUnits.dosage = unit
        defaultUnits[itemType] = itemUnits
    }
}
