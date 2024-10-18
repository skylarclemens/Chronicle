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
    public var sessions: [Session]?
    
    init(id: UUID = UUID(), createdAt: Date = Date(), name: String = "", category: ActivityCategory? = nil, symbol: String? = nil, isCustom: Bool = false, sessions: [Session]? = []) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.category = category
        self.symbol = symbol
        self.isCustom = isCustom
        self.sessions = sessions
    }
}

public enum ActivityCategory: String, Codable, CaseIterable {
    case entertainment, relaxation, creativity, outdoors, exercise, social, food, productivity, selfcare, misc
    
    public var id: Self { return self }
    
    var label: String {
        switch self {
        case .entertainment:
            "Entertainment"
        case .relaxation:
            "Relaxation"
        case .creativity:
            "Creativity"
        case .outdoors:
            "Outdoors"
        case .exercise:
            "Exercise"
        case .social:
            "Social"
        case .food:
            "Food"
        case .productivity:
            "Productivity"
        case .selfcare:
            "Self-care"
        case .misc:
            "Miscellaneous"
        }
    }
}

extension Activity {
    static let predefinedData: [Activity] = [
        // Entertainment
        Activity(name: "Watching TV", category: .entertainment, symbol: "tv"),
        Activity(name: "Watching a Movie", category: .entertainment, symbol: "movieclapper"),
        Activity(name: "Listening to Music", category: .entertainment, symbol: "headphones"),
        Activity(name: "Gaming", category: .entertainment, symbol: "gamecontroller"),
        Activity(name: "Attending a Concert", category: .entertainment, symbol: "music.mic"),
        Activity(name: "Reading", category: .entertainment, symbol: "book"),
        
        // Relaxation
        Activity(name: "Meditating", category: .relaxation, symbol: "figure.mind.and.body"),
        Activity(name: "Taking a Bath", category: .relaxation, symbol: "bathtub"),
        Activity(name: "Napping", category: .relaxation, symbol: "bed.double"),
        
        // Creativity
        Activity(name: "Drawing", category: .creativity, symbol: "pencil.and.scribble"),
        Activity(name: "Painting", category: .creativity, symbol: "paintpalette"),
        Activity(name: "Writing", category: .creativity, symbol: "pencil.line"),
        Activity(name: "Playing Music", category: .creativity, symbol: "music.quarternote.3"),
        Activity(name: "Crafting", category: .creativity, symbol: "scissors"),
        Activity(name: "Photography", category: .creativity, symbol: "camera"),
        
        // Outdoors
        Activity(name: "Hiking", category: .outdoors, symbol: "figure.hiking"),
        Activity(name: "Gardening", category: .outdoors, symbol: "leaf"),
        Activity(name: "Stargazing", category: .outdoors, symbol: "moon.stars"),
        Activity(name: "Park", category: .outdoors, symbol: "tree"),
        Activity(name: "Beach", category: .outdoors, symbol: "beach.umbrella"),
        Activity(name: "Camping", category: .outdoors, symbol: "tent"),
        Activity(name: "Exploring", category: .outdoors, symbol: "map"),
        
        // Exercise
        Activity(name: "Walking", category: .exercise, symbol: "figure.walk"),
        Activity(name: "Running", category: .exercise, symbol: "figure.run"),
        Activity(name: "Working Out", category: .exercise, symbol: "figure.core.training"),
        Activity(name: "Weight Lifting", category: .exercise, symbol: "figure.strengthtraining.traditional"),
        Activity(name: "Yoga", category: .exercise, symbol: "figure.yoga"),
        Activity(name: "Dancing", category: .exercise, symbol: "figure.dance"),
        Activity(name: "Stretching", category: .exercise, symbol: "figure.flexibility"),
        Activity(name: "Swimming", category: .exercise, symbol: "figure.pool.swim"),
        Activity(name: "Bicycle Riding", category: .exercise, symbol: "bicycle"),
        Activity(name: "General Exercise", category: .exercise, symbol: "figure.run"),
        
        // Social
        Activity(name: "Hanging with Friends", category: .social, symbol: "person.2"),
        Activity(name: "Date Night", category: .social, symbol: "heart"),
        Activity(name: "Party", category: .social, symbol: "party.popper"),
        Activity(name: "Game Night", category: .social, symbol: "dice"),
        Activity(name: "Jam Session", category: .social, symbol: "guitars"),
        Activity(name: "Bar", category: .social, symbol: "wineglass"),
        Activity(name: "Clubbing", category: .social, symbol: "laser.burst"),
        
        // Food
        Activity(name: "Cooking", category: .food, symbol: "frying.pan"),
        Activity(name: "Baking", category: .food, symbol: "birthday.cake"),
        Activity(name: "Snacking", category: .food, symbol: "takeoutbag.and.cup.and.straw"),
        Activity(name: "Eating", category: .food, symbol: "fork.knife"),
        Activity(name: "Dining Out", category: .food, symbol: "menucard"),
        
        // Productivity
        Activity(name: "Studying", category: .productivity, symbol: "graduationcap"),
        Activity(name: "Working", category: .productivity, symbol: "briefcase"),
        Activity(name: "Cleaning", category: .productivity, symbol: "sink"),
        Activity(name: "Organizing", category: .productivity, symbol: "shippingbox"),
        Activity(name: "Learning a New Skill", category: .productivity, symbol: "lightbulb"),
        Activity(name: "Planning", category: .productivity, symbol: "calendar"),
        
        // Self-care
        Activity(name: "Journaling", category: .selfcare, symbol: "book"),
        Activity(name: "Skincare Routine", category: .selfcare, symbol: "hands.and.sparkles.fill"),
        Activity(name: "Self-reflection", category: .selfcare, symbol: "brain.filled.head.profile"),
        Activity(name: "Mindfulness", category: .selfcare, symbol: "figure.mind.and.body"),
        
        // Miscellaneous
        Activity(name: "Chilling", category: .misc, symbol: "sofa"),
        Activity(name: "Daydreaming", category: .misc, symbol: "cloud"),
        Activity(name: "Volunteering", category: .misc, symbol: "heart.circle"),
        Activity(name: "Shopping", category: .misc, symbol: "cart"),
        Activity(name: "Traveling", category: .misc, symbol: "airplane"),
    ]
}
