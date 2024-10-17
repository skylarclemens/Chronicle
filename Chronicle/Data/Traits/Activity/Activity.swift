//
//  Activity.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/17/24.
//

import Foundation
import SwiftData

@Model
public class Activity {
    public var id: UUID?
    public var createdAt: Date = Date()
    public var name: String = ""
    public var category: ActivityCategory?
    public var symbol: String?
    public var isCustom: Bool = false
    public var entries: [ActivityEntry]?
    
    init(id: UUID = UUID(), createdAt: Date = Date(), name: String = "", category: ActivityCategory? = nil, symbol: String? = nil, isCustom: Bool = false, entries: [ActivityEntry]? = []) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.category = category
        self.symbol = symbol
        self.isCustom = isCustom
        self.entries = entries
    }
}

public enum ActivityCategory: String, Codable, CaseIterable {
    case entertainment, relaxation, creativity, outdoors, exercise, social, food, productivity, selfcare, misc
}

extension Activity {
    static let predefinedData: [Activity] = [
        // Entertainment
        Activity(name: "Watching TV", category: .entertainment),
        Activity(name: "Watching Movie", category: .entertainment),
        Activity(name: "Listening to Music", category: .entertainment),
        Activity(name: "Gaming", category: .entertainment),
        Activity(name: "Attending Concert", category: .entertainment),
        Activity(name: "Listening to Podcast", category: .entertainment),
        
        // Relaxation
        Activity(name: "Reading", category: .relaxation),
        Activity(name: "Meditating", category: .relaxation),
        Activity(name: "Taking a Bath", category: .relaxation),
        Activity(name: "Napping", category: .relaxation),
        
        // Creativity
        Activity(name: "Drawing", category: .creativity),
        Activity(name: "Painting", category: .creativity),
        Activity(name: "Writing", category: .creativity),
        Activity(name: "Playing Music", category: .creativity),
        Activity(name: "Crafting", category: .creativity),
        Activity(name: "Photography", category: .creativity),
        
        // Outdoors
        Activity(name: "Hiking", category: .outdoors),
        Activity(name: "Gardening", category: .outdoors),
        Activity(name: "Stargazing", category: .outdoors),
        Activity(name: "Beach", category: .outdoors),
        Activity(name: "Camping", category: .outdoors),
        Activity(name: "Exploring", category: .outdoors),
        
        // Exercise
        Activity(name: "Walking", category: .exercise),
        Activity(name: "Running", category: .exercise),
        Activity(name: "Working Out", category: .exercise),
        Activity(name: "Weight Lifting", category: .exercise),
        Activity(name: "Yoga", category: .exercise),
        Activity(name: "Dancing", category: .exercise),
        Activity(name: "Stretching", category: .exercise),
        Activity(name: "Swimming", category: .exercise),
        Activity(name: "General Exercise", category: .exercise),
        
        // Social
        Activity(name: "Hanging with Friends", category: .social),
        Activity(name: "Date Night", category: .social),
        Activity(name: "Party", category: .social),
        Activity(name: "Game Night", category: .social),
        Activity(name: "Jam Session", category: .social),
        
        // Food
        Activity(name: "Cooking", category: .food),
        Activity(name: "Baking", category: .food),
        Activity(name: "Snacking", category: .food),
        Activity(name: "Dining Out", category: .food),
        
        // Productivity
        Activity(name: "Studying", category: .productivity),
        Activity(name: "Working", category: .productivity),
        Activity(name: "Cleaning", category: .productivity),
        Activity(name: "Organizing", category: .productivity),
        Activity(name: "Learning a New Skill", category: .productivity),
        
        // Self-care
        Activity(name: "Journaling", category: .selfcare),
        Activity(name: "Skincare Routine", category: .selfcare),
        Activity(name: "Self-reflection", category: .selfcare),
        Activity(name: "Mindfulness", category: .selfcare),
        
        // Miscellaneous
        Activity(name: "Daydreaming", category: .misc),
        Activity(name: "People Watching", category: .misc),
    ]
}
