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
    @Relationship(deleteRule: .cascade)
    public var traits: [SessionTrait]
    
    var effects: [SessionTrait] {
        traits.filter { $0.itemTrait?.trait.type == .effect }
    }
    
    var sortedMoods: [SessionTrait] {
        let moods = effects.filter { $0.itemTrait?.trait.subtype == .mood }
        return moods.sorted {
            $0.intensity ?? 0 > $1.intensity ?? 0
        }
    }
    
    var sortedWellness: [SessionTrait] {
        let wellness = effects.filter { $0.itemTrait?.trait.subtype == .wellness }
        return wellness.sorted {
            $0.itemTrait?.traitName ?? "" > $1.itemTrait?.traitName ?? ""
        }
    }
    
    var flavors: [SessionTrait] {
        traits.filter { $0.itemTrait?.trait.type == .flavor }
    }
    
    var sortedFlavors: [SessionTrait] {
        return flavors.sorted { $0.itemTrait?.trait.name ?? "" > $1.itemTrait?.trait.name ?? "" }
    }
    
    init(id: UUID = UUID(), createdAt: Date = Date(), title: String = "", date: Date = Date(), item: Item? = nil, duration: TimeInterval? = nil, notes: String? = nil, location: String? = nil, traits: [SessionTrait] = []) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.date = date
        self.item = item
        self.duration = duration
        self.notes = notes
        self.location = location
        self.traits = traits
    }
    
    static func predicate(
        date: Date?
    ) -> Predicate<Session> {
        let calendar = Calendar.current
        if let date {
            let startOfDay = calendar.startOfDay(for: date)
            var components = DateComponents()
            components.day = 1
            components.second = -1
            let endOfDay = calendar.date(byAdding: components, to: startOfDay)!
            return #Predicate<Session> { session in
                return startOfDay <= session.date && session.date <= endOfDay
            }
        }
        return #Predicate<Session> { session in
            return true
        }
    }
}
