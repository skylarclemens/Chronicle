//
//  InventorySnapshot.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/11/24.
//

import Foundation
import SwiftData

@Model
public class InventorySnapshot {
    public var date = Date()
    public var amount: Amount?
    public var item: Item?
    
    var displayValue: Double? {
        if let amount {
            return abs(amount.value)
        }
        return nil
    }
    
    var unit: String {
        amount?.unit.rawValue ?? ""
    }
    
    init(date: Date = Date(), amount: Amount? = nil, item: Item? = nil) {
        self.date = date
        self.amount = amount
        self.item = item
    }
}
