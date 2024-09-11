//
//  ItemTrait.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/27/24.
//

import Foundation
import SwiftData

@Model
public class ItemTrait {
    @Attribute(.unique) public var id: String
    public var trait: Trait
    public var item: Item?
    @Relationship(deleteRule: .cascade)
    public var sessionTraits: [SessionTrait]
    
    var totalCount: Int {
        return sessionTraits.count
    }
    
    var totalIntensity: Int {
        return sessionTraits.reduce(0) { $0 + ($1.intensity ?? 0) }
    }
    
    var averageIntensity: Double {
        return sessionTraits.isEmpty ? 0 : Double(totalIntensity) / Double(sessionTraits.count)
    }
    
    var traitName: String {
        return trait.name
    }
    
    var traitEmoji: String {
        return trait.emoji ?? ""
    }
    
    var traitColor: ColorData {
        return trait.color
    }
    
    init(trait: Trait, item: Item? = nil, sessionTraits: [SessionTrait] = []) {
        self.id = UUID().uuidString
        self.trait = trait
        self.item = item
        self.sessionTraits = sessionTraits
    }
}
