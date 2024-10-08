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
    public var amount: Amount?
    public var price: Double?
    public var location: LocationInfo?
    public var isAdjustment: Bool = false
    public var item: Item?
    public var accessory: Accessory?
    
    init(date: Date, amount: Amount? = nil, unit: String? = nil, price: Double? = nil, location: LocationInfo? = nil, isAdjustment: Bool = false, item: Item? = nil, accessory: Accessory? = nil) {
        self.id = UUID().uuidString
        self.date = date
        self.amount = amount
        self.price = price
        self.location = location
        self.isAdjustment = isAdjustment
        self.item = item
        self.accessory = accessory
    }
}
