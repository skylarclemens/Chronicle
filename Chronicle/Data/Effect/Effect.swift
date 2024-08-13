//
//  Effect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class Effect {
    public var name: String
    public var emoji: String
    public var type: EffectType
    public var color: String?
    
    init(name: String, emoji: String, type: EffectType, color: String? = nil) {
        self.name = name
        self.emoji = emoji
        self.type = type
        self.color = color
    }
    
    public static let predefinedEffects: [Effect] = [
        Effect(name: "Relaxed", emoji: "😌", type: .mood),
        Effect(name: "Energetic", emoji: "⚡️", type: .mood),
        Effect(name: "Happy", emoji: "😊", type: .mood),
        Effect(name: "Focused", emoji: "🎯", type: .mood),
        Effect(name: "Creative", emoji: "🎨", type: .mood),
        Effect(name: "Euphoric", emoji: "😃", type: .mood),
        Effect(name: "Talkative", emoji: "🗣️", type: .mood),
        Effect(name: "Giggly", emoji: "😂", type: .mood),
        Effect(name: "Sleepy", emoji: "😴", type: .mood),
        Effect(name: "Hungry", emoji: "🍽️", type: .mood),
        Effect(name: "Uplifted", emoji: "🌅", type: .mood),
        Effect(name: "Aroused", emoji: "🔥", type: .mood),
        Effect(name: "Tingly", emoji: "✨", type: .wellness),
        Effect(name: "Calm", emoji: "🧘", type: .mood),
        Effect(name: "Paranoid", emoji: "😨", type: .mood),
        Effect(name: "Anxious", emoji: "😟", type: .mood),
        Effect(name: "Uplifted Spirits", emoji: "🌟", type: .mood),
        Effect(name: "Sociable", emoji: "👥", type: .mood),
        Effect(name: "Motivated", emoji: "🚀", type: .mood),
        Effect(name: "Chilled", emoji: "❄️", type: .mood),
        Effect(name: "Mind High", emoji: "💭", type: .mood),
        Effect(name: "Inspired", emoji: "💡", type: .mood),
        Effect(name: "Giggly and Talkative", emoji: "🎉", type: .mood),
        Effect(name: "Alert", emoji: "👀", type: .mood),
        Effect(name: "Creative Flow", emoji: "🌈", type: .mood),
        Effect(name: "Mellow", emoji: "🎶", type: .mood),
        Effect(name: "Comfortable", emoji: "🛏️", type: .mood),
        Effect(name: "Spiritual", emoji: "🙏", type: .mood),
        Effect(name: "Blissful", emoji: "🥰", type: .mood),
        Effect(name: "Awake", emoji: "🌅", type: .mood),
        Effect(name: "Tranquil", emoji: "🏞️", type: .mood),
        Effect(name: "Stimulated", emoji: "💥", type: .mood),
        Effect(name: "Optimistic", emoji: "🌞", type: .mood),
        Effect(name: "Grounded", emoji: "🌍", type: .mood),
        Effect(name: "Heavy", emoji: "🏋️", type: .mood),
        Effect(name: "Mindful", emoji: "🧠", type: .mood),
        Effect(name: "Joyful", emoji: "😁", type: .mood),
        Effect(name: "Chill", emoji: "😎", type: .mood),
        Effect(name: "Vivid Thoughts", emoji: "💭", type: .mood),
        Effect(name: "Meditative", emoji: "🧘‍♀️", type: .mood),
        Effect(name: "Soothed", emoji: "💆", type: .wellness),
        Effect(name: "Comforted", emoji: "🤗", type: .wellness),
        Effect(name: "Relaxed Body", emoji: "💆‍♂️", type: .wellness),
        Effect(name: "Clear-headed", emoji: "🧠", type: .wellness),
        Effect(name: "Couch Locked", emoji: "🛋️", type: .wellness),
        Effect(name: "Headache Relief", emoji: "🤕", type: .wellness),
        Effect(name: "Stress Relief", emoji: "🌿", type: .wellness),
        Effect(name: "Anxiety Relief", emoji: "😟", type: .wellness),
        Effect(name: "Sleep Aid", emoji: "💤", type: .wellness),
        Effect(name: "Appetite Stimulation", emoji: "🍴", type: .wellness),
        Effect(name: "Pain Relief", emoji: "💊", type: .wellness),
        Effect(name: "Relaxed Muscles", emoji: "💪", type: .wellness),
        Effect(name: "Dizzy", emoji: "💫", type: .wellness),
        Effect(name: "Numb", emoji: "🦶", type: .wellness),
    ]
}
