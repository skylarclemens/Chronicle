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
    public var favorite: Bool
    @Attribute(.externalStorage) public var imagesData: [Data]?
    @Relationship(deleteRule: .cascade, inverse: \Mood.session)
    public var mood: Mood?
    
    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        title: String = "",
        date: Date = Date(),
        item: Item? = nil,
        duration: TimeInterval? = nil,
        notes: String? = nil,
        location: String? = nil,
        favorite: Bool = false,
        moods: Mood? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.date = date
        self.item = item
        self.duration = duration
        self.notes = notes
        self.location = location
        self.favorite = favorite
        self.mood = mood
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
