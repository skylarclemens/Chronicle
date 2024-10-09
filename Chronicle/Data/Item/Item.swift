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
    public var selectedUnit: AcceptedUnit?
    public var brand: String?
    public var compounds: [Compound] = []
    public var ingredients: [String] = []
    public var favorite: Bool = false
    @Attribute(.externalStorage) public var imagesData: [Data]?
    
    @Relationship(deleteRule: .cascade, inverse: \Purchase.item)
    public var purchases: [Purchase]?
    @Relationship(deleteRule: .noAction, inverse: \Tag.items)
    public var tags: [Tag]?
    @Relationship(deleteRule: .nullify, inverse: \Session.item)
    public var sessions: [Session]?
    
    var cannabinoids: [Compound] {
        compounds.filter { $0.type == .cannabinoid }
    }
    
    var terpenes: [Compound] {
        compounds.filter { $0.type == .terpene }
    }
    
    var remainingAmount: Double {
        let totalPurchased = purchases?.reduce(0) { $0 + ($1.amount?.value ?? 0) } ?? 0
        let totalUsed = sessions?.reduce(0) { $0 + ($1.amountConsumed ?? 0) } ?? 0
        return max(totalPurchased - totalUsed, 0)
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
        selectedUnit: AcceptedUnit? = nil,
        compounds: [Compound] = [],
        ingredients: [String] = [],
        favorite: Bool = false,
        purchases: [Purchase]? = [],
        tags: [Tag]? = [],
        sessions: [Session]? = []
    ) {
        self.id = id
        self.name = name
        self.strain = strain
        self.createdAt = createdAt
        self.type = type
        self.amount = amount
        self.selectedUnit = selectedUnit
        self.compounds = compounds
        self.ingredients = ingredients
        self.favorite = favorite
        self.purchases = purchases
        self.tags = tags
        self.sessions = sessions
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
    
    func updateRemainingAmount(newAmount: Double) {
        let adjustment = newAmount - remainingAmount
        let adjustmentRecord = Purchase(date: Date(), amount: Amount(value: adjustment, unit: ""), isAdjustment: true)
        purchases?.append(adjustmentRecord)
    }
    
    func mostRecentSessions(_ num: Int = 5) -> [Session] {
        Array(sessions?.sorted(by: { $0.date.compare($1.date) == .orderedDescending }).prefix(num) ?? [])
    }
}
