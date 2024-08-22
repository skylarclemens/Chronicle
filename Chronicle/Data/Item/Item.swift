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
    public var composition: [Cannabinoid]
    public var terpenes: [Terpene]
    public var ingredients: [String]
    public var purchasePrice: Double?
    public var purchaseDate: Date?
    public var purchaseLocation: String?
    @Attribute(.externalStorage) public var imagesData: [Data]?
    @Relationship(deleteRule: .cascade)
    public var effects: [ItemEffect]
    @Relationship(deleteRule: .cascade)
    public var flavors: [ItemFlavor]
    @Relationship(deleteRule: .nullify)
    public var sessions: [Session]
    
    var sortedEffects: [ItemEffect] {
        effects.sorted {
            $0.averageIntensity > $1.averageIntensity
        }
    }
    
    var sortedFlavors: [ItemFlavor] {
        flavors.sorted {
            if $0.count == $1.count {
                return $0.flavor.name < $1.flavor.name
            }
            
            return $0.count > $1.count
        }
    }
    
    init(id: UUID = UUID(), name: String, strain: Strain? = nil, createdAt: Date = Date(), type: ItemType, amount: Double = 0, composition: [Cannabinoid] = [], terpenes: [Terpene] = [], ingredients: [String] = [], effects: [ItemEffect] = [], flavors: [ItemFlavor] = [], sessions: [Session] = []) {
        self.id = id
        self.name = name
        self.strain = strain
        self.createdAt = createdAt
        self.type = type
        self.amount = amount
        self.composition = composition
        self.terpenes = terpenes
        self.ingredients = ingredients
        self.effects = effects
        self.flavors = flavors
        self.sessions = sessions
    }
}
