//
//  Item.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import Foundation
import SwiftData

@Model public class Item {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var strain: Strain?
    public var createdAt: Date
    public var type: ItemType
    public var amount: Double
    public var unit: String
    public var composition: [String: Double] // ["THC": 99.9]
    public var purchaseDate: Date
    @Attribute(.externalStorage) public var itemImage: Data?
    @Relationship(inverse: \Session.item)
    public var sessions: [Session]
    
    init(id: UUID = UUID(), name: String, strain: Strain? = nil, createdAt: Date = Date(), type: ItemType, amount: Double = 0, unit: String = "", composition: [String : Double] = [:], purchaseDate: Date = Date(), sessions: [Session] = []) {
        self.id = id
        self.name = name
        self.strain = strain
        self.createdAt = createdAt
        self.type = type
        self.amount = amount
        self.unit = unit
        self.composition = composition
        self.purchaseDate = purchaseDate
        self.sessions = sessions
    }
}
