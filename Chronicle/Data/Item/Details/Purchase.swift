//
//  Purchase.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/15/24.
//

import Foundation
import SwiftData

@Model public class Purchase {
    public var id: String
    public var date: Date
    public var amount: Amount?
    public var price: Double?
    public var location: String?
    public var isAdjustment: Bool
    @Relationship public var item: Item?
    
    init(date: Date, amount: Amount? = nil, unit: String? = nil, price: Double? = nil, location: String? = nil, isAdjustment: Bool = false, item: Item? = nil) {
        self.id = UUID().uuidString
        self.date = date
        self.amount = amount
        self.price = price
        self.location = location
        self.isAdjustment = isAdjustment
        self.item = item
    }
}
