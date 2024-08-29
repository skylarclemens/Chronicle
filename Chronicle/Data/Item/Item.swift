//
//  Item.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model public class Item {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var strain: Strain?
    public var createdAt: Date
    public var type: ItemType
    public var brand: String?
    public var subtype: String?
    public var amount: Double
    public var dosage: Dosage?
    public var compounds: [Compound]
    public var ingredients: [String]
    public var purchaseInfo: PurchaseInfo?
    public var favorite: Bool
    @Attribute(.externalStorage) public var imagesData: [Data]?
    @Relationship(deleteRule: .cascade, inverse: \ItemTrait.item)
    public var traits: [ItemTrait]
    @Relationship(deleteRule: .nullify, inverse: \Session.item)
    public var sessions: [Session]
    
    var cannabinoids: [Compound] {
        compounds.filter { $0.type == .cannabinoid }
    }
    
    var terpenes: [Compound] {
        compounds.filter { $0.type == .terpene }
    }
    
    init(id: UUID = UUID(), name: String, strain: Strain? = nil, createdAt: Date = Date(), type: ItemType, amount: Double = 0, compounds: [Compound] = [], ingredients: [String] = [], favorite: Bool = false, traits: [ItemTrait] = [], sessions: [Session] = []) {
        self.id = id
        self.name = name
        self.strain = strain
        self.createdAt = createdAt
        self.type = type
        self.amount = amount
        self.compounds = compounds
        self.ingredients = ingredients
        self.favorite = favorite
        self.traits = traits
        self.sessions = sessions
    }
    
    static func predicate(
        filter: ItemFilter = .all,
        searchText: String
    ) -> Predicate<Item> {
        if filter == .favorites {
            return #Predicate<Item> { item in
                (searchText.isEmpty || item.name.localizedStandardContains(searchText))
                &&
                item.favorite
            }
        }
        return #Predicate<Item> { item in
            searchText.isEmpty || item.name.localizedStandardContains(searchText)
        }
    }
}
