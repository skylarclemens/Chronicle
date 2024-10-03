//
//  Emotion.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/27/24.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct Emotion: Identifiable, Codable, Hashable, Plottable {
    var id: String { name }
    var name: String
    var emoji: String?
    
    init(name: String, emoji: String? = nil) {
        self.name = name
        self.emoji = emoji
    }
    
    var primitivePlottable: String {
        return "\(emoji == nil ? "" : emoji! + " ")\(name)"
    }
    
    init?(primitivePlottable: String) {
        return nil
    }
}

extension Emotion {
    public static let initialEmotions: [Emotion] = [
        Emotion(name: "Relaxed", emoji: "😌"),
        Emotion(name: "Energetic", emoji: "⚡️"),
        Emotion(name: "Happy", emoji: "😊"),
        Emotion(name: "Focused", emoji: "🎯"),
        Emotion(name: "Creative", emoji: "🎨"),
        Emotion(name: "Euphoric", emoji: "😃"),
        Emotion(name: "Talkative", emoji: "🗣️"),
        Emotion(name: "Giggly", emoji: "😂"),
        Emotion(name: "Sleepy", emoji: "😴"),
        Emotion(name: "Hungry", emoji: "🍽️"),
        Emotion(name: "Uplifted", emoji: "🌟"),
        Emotion(name: "Aroused", emoji: "🔥"),
        Emotion(name: "Calm", emoji: "🧘"),
        Emotion(name: "Paranoid", emoji: "😨"),
        Emotion(name: "Anxious", emoji: "😟"),
        Emotion(name: "Sociable", emoji: "👥"),
        Emotion(name: "Motivated", emoji: "🚀"),
        Emotion(name: "Mind High", emoji: "💭"),
        Emotion(name: "Inspired", emoji: "💡"),
        Emotion(name: "Alert", emoji: "👀"),
        Emotion(name: "Mellow", emoji: "🎶"),
        Emotion(name: "Comfortable", emoji: "🛏️"),
        Emotion(name: "Spiritual", emoji: "🙏"),
        Emotion(name: "Blissful", emoji: "🥰"),
        Emotion(name: "Awake", emoji: "🌅"),
        Emotion(name: "Tranquil", emoji: "🏞️"),
        Emotion(name: "Stimulated", emoji: "💥"),
        Emotion(name: "Optimistic", emoji: "🌞"),
        Emotion(name: "Grounded", emoji: "🌍"),
        Emotion(name: "Heavy", emoji: "🏋️"),
        Emotion(name: "Mindful", emoji: "🧠"),
        Emotion(name: "Joyful", emoji: "😁"),
        Emotion(name: "Chill", emoji: "😎"),
        Emotion(name: "Vivid Thoughts", emoji: "💭"),
        Emotion(name: "Meditative", emoji: "🧘‍♀️")
    ]
}
