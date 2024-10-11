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
    public var id: UUID?
    public var name: String = ""
    public var strain: Strain?
    public var createdAt: Date = Date()
    public var type: ItemType?
    public var subtype: String?
    public var amount: Amount?
    public var dosage: Amount?
    public var selectedUnits: ItemUnits?
    public var brand: String?
    public var compounds: [Compound] = []
    public var ingredients: [String] = []
    public var favorite: Bool = false
    @Attribute(.externalStorage) public var imagesData: [Data]?
    
    @Relationship(deleteRule: .nullify, inverse: \Session.item)
    public var sessions: [Session]?
    @Relationship(deleteRule: .cascade, inverse: \InventoryTransaction.item)
    public var transactions: [InventoryTransaction]?
    @Relationship(deleteRule: .noAction, inverse: \Tag.items)
    public var tags: [Tag]?
    
    var cannabinoids: [Compound] {
        compounds.filter { $0.type == .cannabinoid }
    }
    
    var terpenes: [Compound] {
        compounds.filter { $0.type == .terpene }
    }
    
    var purchases: [InventoryTransaction] {
        transactions?.filter { $0.type == .purchase } ?? []
    }
    
    var currentInventory: Amount? {
        guard let transactions = transactions?.filter({ $0.updateInventory }), !transactions.isEmpty else { return nil }
        let totalValue = transactions.reduce(0) { $0 + ($1.amount?.value ?? 0) }
        return Amount(value: totalValue, unit: selectedUnits?.amount ?? AcceptedUnit.count)
    }
    
    var moods: [Mood] {
        return sessions?.compactMap { $0.mood } ?? []
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        strain: Strain? = nil,
        createdAt: Date = Date(),
        type: ItemType,
        amount: Amount? = nil,
        dosage: Amount? = nil,
        selectedUnits: ItemUnits? = nil,
        compounds: [Compound] = [],
        ingredients: [String] = [],
        favorite: Bool = false,
        sessions: [Session]? = [],
        transactions: [InventoryTransaction]? = [],
        tags: [Tag]? = []
    ) {
        self.id = id
        self.name = name
        self.strain = strain
        self.createdAt = createdAt
        self.type = type
        self.amount = amount
        self.dosage = dosage
        self.selectedUnits = selectedUnits
        self.compounds = compounds
        self.ingredients = ingredients
        self.favorite = favorite
        self.sessions = sessions
        self.transactions = transactions
        self.tags = tags
    }
    
    static func predicate(
        filter: InventoryFilter = .all,
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
    
    func mostRecentSessions(_ num: Int = 5) -> [Session] {
        Array(sessions?.sorted(by: { $0.date.compare($1.date) == .orderedDescending }).prefix(num) ?? [])
    }
}
