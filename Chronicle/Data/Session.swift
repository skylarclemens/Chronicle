//
//  Experience.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class Session {
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date
    public var date: Date
    public var item: Item
    public var duration: TimeInterval?
    public var effects: [SessionEffect]
    public var flavors: [SessionFlavor]
    public var notes: String?
    public var location: String?
    
    init(id: UUID = UUID(), createdAt: Date = Date(), date: Date = Date(), item: Item, duration: TimeInterval? = nil, effects: [SessionEffect] = [], flavors: [SessionFlavor] = [], notes: String? = nil, location: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.date = date
        self.item = item
        self.duration = duration
        self.effects = effects
        self.flavors = flavors
        self.notes = notes
        self.location = location
    }
}


