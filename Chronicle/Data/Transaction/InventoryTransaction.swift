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
    public var date: Date = Date()
    public var note: String?
    
    public var item: Item?
    public var session: Session?
    public var purchase: Purchase?
    
    init(id: UUID = UUID(),
         type: TransactionType = .purchase,
         amount: Amount? = nil,
         date: Date = Date(),
         note: String? = nil,
         item: Item? = nil, session:
         Session? = nil,
         purchase: Purchase? = nil) {
        self.id = id
        self.type = type
        self.amount = amount
        self.note = note
        self.item = item
        self.session = session
        self.purchase = purchase
    }
}

public enum TransactionType: String, Codable {
    case purchase
    case consumption
    case adjustment
}
