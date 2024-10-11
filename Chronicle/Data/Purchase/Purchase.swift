//
//  Purchase.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/15/24.
//

import Foundation
import SwiftData

@Model public class Purchase {
    public var id: String?
    public var date: Date = Date()
    public var price: Double?
    public var location: LocationInfo?
    public var isAdjustment: Bool = false
    public var accessory: Accessory?
    
    @Relationship(deleteRule: .cascade, inverse: \InventoryTransaction.purchase)
    public var transaction: InventoryTransaction?
    
    init(date: Date, price: Double? = nil, location: LocationInfo? = nil, isAdjustment: Bool = false, accessory: Accessory? = nil, transaction: InventoryTransaction? = nil) {
        self.id = UUID().uuidString
        self.date = date
        self.price = price
        self.location = location
        self.isAdjustment = isAdjustment
        self.accessory = accessory
        self.transaction = transaction
    }
}
