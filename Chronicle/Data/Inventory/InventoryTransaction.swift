//
//  Transaction.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/10/24.
//

import Foundation
import SwiftData

@Model
public class InventoryTransaction {
    public var id: UUID?
    public var type: TransactionType = TransactionType.purchase
    public var amount: Amount?
    public var setAmount: Amount?
    public var date: Date = Date()
    public var note: String?
    public var updateInventory: Bool = true
    
    public var item: Item?
    public var session: Session?
    public var purchase: Purchase?
    
    var displayValue: Double? {
        if let amount {
            return abs(amount.value)
        }
        return nil
    }
    
    var unit: String {
        amount?.unit.rawValue ?? ""
    }
    
    init(id: UUID = UUID(),
         type: TransactionType = .purchase,
         amount: Amount? = nil,
         setAmount: Amount? = nil,
         date: Date = Date(),
         note: String? = nil,
         updateInventory: Bool = true,
         item: Item? = nil,
         session: Session? = nil,
         purchase: Purchase? = nil) {
        self.id = id
        self.type = type
        self.amount = amount
        self.setAmount = setAmount
        self.note = note
        self.updateInventory = updateInventory
        self.item = item
        self.session = session
        self.purchase = purchase
    }
}

public enum TransactionType: String, Codable {
    case purchase
    case consumption
    case adjustment
    case set
}
