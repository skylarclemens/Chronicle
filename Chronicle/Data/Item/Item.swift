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
    public var brand: String?
    public var subtype: String?
    public var amount: Double
    public var dosageAmount: Double?
    public var dosageUnit: String?
    public var composition: [String: Double] // ["THC": 99.9]
    public var terpenes: [String] = []
    public var ingredients: [String] = []
    public var purchasePrice: Double?
    public var purchaseDate: Date?
    public var purchaseLocation: String?
    @Attribute(.externalStorage) public var imagesData: [Data]?
    @Relationship(deleteRule: .cascade, inverse: \Session.item)
    public var sessions: [Session]
    
    init(id: UUID = UUID(), name: String, strain: Strain? = nil, createdAt: Date = Date(), type: ItemType, amount: Double = 0, composition: [String: Double] = [:], sessions: [Session] = []) {
        self.id = id
        self.name = name
        self.strain = strain
        self.createdAt = createdAt
        self.type = type
        self.amount = amount
        self.composition = composition
        self.sessions = sessions
    }
}
