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
    public var amountConsumed: Double?
    public var notes: String?
    public var location: String?
    public var favorite: Bool
    @Attribute(.externalStorage) public var imagesData: [Data]?
    @Attribute(.externalStorage) public var audioData: Data?
    @Relationship(inverse: \Accessory.sessions)
    public var accessories: [Accessory]
    @Relationship(deleteRule: .noAction, inverse: \Tag.sessions)
    public var tags: [Tag]
    @Relationship(deleteRule: .cascade, inverse: \Mood.session)
    public var mood: Mood?
    
    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        title: String = "",
        date: Date = Date(),
        item: Item? = nil,
        duration: TimeInterval? = nil,
        amountConsumed: Double? = nil,
        notes: String? = nil,
        location: String? = nil,
        favorite: Bool = false,
        accessories: [Accessory] = [],
        tags: [Tag] = [],
        mood: Mood? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.date = date
        self.item = item
        self.duration = duration
        self.amountConsumed = amountConsumed
        self.notes = notes
        self.location = location
        self.favorite = favorite
        self.accessories = accessories
        self.tags = tags
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
    
    static func dateRangePredicate(
        startDate: Date?, endDate: Date?
    ) -> Predicate<Session> {
        if let startDate, let endDate {
            return #Predicate<Session> { session in
                return session.date >= startDate && session.date <= endDate
            }
        }
        return #Predicate<Session> { session in
            return true
        }
    }
    
    static var dashboardDescriptor: FetchDescriptor<Session> {
        var descriptor = FetchDescriptor<Session>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        descriptor.fetchLimit = 3
        return descriptor
    }
}
