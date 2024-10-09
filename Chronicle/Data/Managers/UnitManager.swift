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
    
    func getDefaultUnit(for itemType: ItemType) -> AcceptedUnit {
        return defaultUnits[itemType]
    }
    
    func setDefaultUnit(_ unit: AcceptedUnit, for itemType: ItemType) {
        defaultUnits[itemType] = unit
    }
}
