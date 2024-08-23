//
//  Session.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model public class Session {
    public var id: UUID
    public var createdAt: Date
    public var title: String
    public var date: Date
    public var item: Item?
    public var duration: TimeInterval?
    public var notes: String?
    public var location: String?
    @Attribute(.externalStorage) public var imagesData: [Data]?
    @Relationship(deleteRule: .cascade) public var effects: [SessionEffect]
    @Relationship(deleteRule: .cascade) public var flavors: [SessionFlavor]
    
    var sortedEffects: [SessionEffect] {
        effects.sorted {
            $0.intensity > $1.intensity
        }
    }
    
    var sortedFlavors: [SessionFlavor] {
        flavors.sorted {
            $0.flavor.name > $1.flavor.name
        }
    }
    
    init(id: UUID = UUID(), createdAt: Date = Date(), title: String = "", date: Date = Date(), item: Item? = nil, duration: TimeInterval? = nil, notes: String? = nil, location: String? = nil, effects: [SessionEffect] = [], flavors: [SessionFlavor] = []) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.date = date
        self.item = item
        self.duration = duration
        self.notes = notes
        self.location = location
        self.effects = effects
        self.flavors = flavors
    }
}
