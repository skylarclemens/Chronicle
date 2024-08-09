//
//  Experience.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class Experience {
    @Attribute(.unique) public var id: UUID
    public var date: Date
    public var item: Item
    public var consumptionMethod: String // "Flower", "Edible", etc.
    public var duration: TimeInterval?
    public var effects: [ExperienceEffect]
    public var flavors: [ExperienceFlavor]
    public var notes: String?
    public var location: String?
    
    init(id: UUID = UUID(), date: Date = Date(), item: Item, consumptionMethod: String, duration: TimeInterval? = nil, effects: [ExperienceEffect] = [], flavors: [ExperienceFlavor] = [], notes: String? = nil, location: String? = nil) {
        self.id = id
        self.date = date
        self.item = item
        self.consumptionMethod = consumptionMethod
        self.duration = duration
        self.effects = effects
        self.flavors = flavors
        self.notes = notes
        self.location = location
    }
}


