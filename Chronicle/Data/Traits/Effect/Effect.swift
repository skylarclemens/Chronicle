//
//  Effect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/19/24.
//

import Foundation
import SwiftData

@Model
public class Effect {
    public var id: UUID?
    public var name: String = ""
    public var emoji: String?
    public var type: EffectType = EffectType.mental
    public var isCustom: Bool = false
    public var sessions: [Session]?
    public var relatedWellness: Wellness?
    
    init(id: UUID? = UUID(), name: String = "", emoji: String? = nil, type: EffectType = EffectType.mental, isCustom: Bool = false, sessions: [Session]? = [], relatedWellness: Wellness? = nil) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.type = type
        self.isCustom = isCustom
        self.sessions = sessions
        self.relatedWellness = relatedWellness
    }
}

public enum EffectType: String, Codable, CaseIterable {
    case mental, physical
    
    public var id: Self { return self }
}

extension Effect {
    static let predefinedData: [Effect] = [
        // Mental Effects
        Effect(name: "Euphoric", emoji: "🌟", type: .mental),
        Effect(name: "Happy", emoji: "😊", type: .mental),
        Effect(name: "Sad", emoji: "😟", type: .mental),
        Effect(name: "Uplifted", emoji: "🚀", type: .mental),
        Effect(name: "Focused", emoji: "🎯", type: .mental),
        Effect(name: "Creative", emoji: "🎨", type: .mental),
        Effect(name: "Giggly", emoji: "😂", type: .mental),
        Effect(name: "Inspired", emoji: "💡", type: .mental),
        Effect(name: "Spiritual", emoji: "✨", type: .mental),
        Effect(name: "Talkative", emoji: "🗣️", type: .mental),
        Effect(name: "Relaxed", emoji: "😌", type: .mental),
        Effect(name: "Stimulated", emoji: "💥", type: .mental),
        Effect(name: "Optimistic", emoji: "🌞", type: .mental),
        Effect(name: "Aroused", emoji: "🔥", type: .mental),
        Effect(name: "Calm", emoji: "🧘", type: .mental),
        Effect(name: "Anxious", emoji: "😰", type: .mental),
        Effect(name: "Paranoid", emoji: "🫣", type: .mental),
        Effect(name: "Confused", emoji: "🤔", type: .mental),
        Effect(name: "Chill", emoji: "😎", type: .mental),
        Effect(name: "Alert", emoji: "👀", type: .mental),
        Effect(name: "Time Distortion", emoji: "⏰", type: .mental),
        Effect(name: "Enhanced Senses", emoji: "👁️‍🗨️", type: .mental),
        Effect(name: "Motivated", emoji: "🚀", type: .mental),
        Effect(name: "Introspective", emoji: "🧠", type: .mental),
        
        // Physical Effects
        Effect(name: "Dry Mouth", emoji: "🏜️", type: .physical),
        Effect(name: "Dry Eyes", emoji: "👁️", type: .physical),
        Effect(name: "Red Eyes", emoji: "👁️", type: .physical),
        Effect(name: "Couch Lock", emoji: "🛋️", type: .physical),
        Effect(name: "Energetic", emoji: "⚡", type: .physical),
        Effect(name: "Relaxed Muscles", emoji: "💆", type: .physical),
        Effect(name: "Hungry", emoji: "🍽️", type: .physical),
        Effect(name: "Pain Relief", emoji: "🩹", type: .physical),
        Effect(name: "Sleepy", emoji: "😴", type: .physical),
        Effect(name: "Insomnia", emoji: "🛌", type: .physical),
        Effect(name: "Nauseous", emoji: "🤢", type: .physical),
        Effect(name: "Headache", emoji: "🤕", type: .physical),
        Effect(name: "Dizziness", emoji: "💫", type: .physical),
        Effect(name: "Jittery", emoji: "🫨", type: .physical),
    ]
}
