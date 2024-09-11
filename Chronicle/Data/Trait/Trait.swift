//
//  Trait.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/27/24.
//

import Foundation
import SwiftData

@Model
public class Trait {
    @Attribute(.unique) public var id: String
    public var name: String
    public var emoji: String?
    public var type: TraitType
    public var subtype: EffectType?
    public var color: ColorData
    
    init(name: String, emoji: String? = nil, type: TraitType, subtype: EffectType? = nil, color: ColorData = ColorData(color: .accent)) {
        self.id = UUID().uuidString
        self.name = name
        self.emoji = emoji
        self.type = type
        self.subtype = subtype
        self.color = color
    }
}

public enum TraitType: String, Codable {
    case effect, flavor, mood
}

public enum EffectType: String, Identifiable, CaseIterable, Codable {
    case mood, wellness
    
    public var id: Self { return self }
}

extension Trait {
    
    // General mood effects
    public static let predefinedEffects: [Trait] = [
        Trait(name: "Relaxed", emoji: "😌", type: .effect, subtype: .mood),
        Trait(name: "Energetic", emoji: "⚡️", type: .effect, subtype: .mood),
        Trait(name: "Happy", emoji: "😊", type: .effect, subtype: .mood),
        Trait(name: "Focused", emoji: "🎯", type: .effect, subtype: .mood),
        Trait(name: "Creative", emoji: "🎨", type: .effect, subtype: .mood),
        Trait(name: "Euphoric", emoji: "😃", type: .effect, subtype: .mood),
        Trait(name: "Talkative", emoji: "🗣️", type: .effect, subtype: .mood),
        Trait(name: "Giggly", emoji: "😂", type: .effect, subtype: .mood),
        Trait(name: "Sleepy", emoji: "😴", type: .effect, subtype: .mood),
        Trait(name: "Hungry", emoji: "🍽️", type: .effect, subtype: .mood),
        Trait(name: "Uplifted", emoji: "🌟", type: .effect, subtype: .mood),
        Trait(name: "Aroused", emoji: "🔥", type: .effect, subtype: .mood),
        Trait(name: "Calm", emoji: "🧘", type: .effect, subtype: .mood),
        Trait(name: "Paranoid", emoji: "😨", type: .effect, subtype: .mood),
        Trait(name: "Anxious", emoji: "😟", type: .effect, subtype: .mood),
        Trait(name: "Sociable", emoji: "👥", type: .effect, subtype: .mood),
        Trait(name: "Motivated", emoji: "🚀", type: .effect, subtype: .mood),
        Trait(name: "Mind High", emoji: "💭", type: .effect, subtype: .mood),
        Trait(name: "Inspired", emoji: "💡", type: .effect, subtype: .mood),
        Trait(name: "Alert", emoji: "👀", type: .effect, subtype: .mood),
        Trait(name: "Mellow", emoji: "🎶", type: .effect, subtype: .mood),
        Trait(name: "Comfortable", emoji: "🛏️", type: .effect, subtype: .mood),
        Trait(name: "Spiritual", emoji: "🙏", type: .effect, subtype: .mood),
        Trait(name: "Blissful", emoji: "🥰", type: .effect, subtype: .mood),
        Trait(name: "Awake", emoji: "🌅", type: .effect, subtype: .mood),
        Trait(name: "Tranquil", emoji: "🏞️", type: .effect, subtype: .mood),
        Trait(name: "Stimulated", emoji: "💥", type: .effect, subtype: .mood),
        Trait(name: "Optimistic", emoji: "🌞", type: .effect, subtype: .mood),
        Trait(name: "Grounded", emoji: "🌍", type: .effect, subtype: .mood),
        Trait(name: "Heavy", emoji: "🏋️", type: .effect, subtype: .mood),
        Trait(name: "Mindful", emoji: "🧠", type: .effect, subtype: .mood),
        Trait(name: "Joyful", emoji: "😁", type: .effect, subtype: .mood),
        Trait(name: "Chill", emoji: "😎", type: .effect, subtype: .mood),
        Trait(name: "Vivid Thoughts", emoji: "💭", type: .effect, subtype: .mood),
        Trait(name: "Meditative", emoji: "🧘‍♀️", type: .effect, subtype: .mood)
    ]
    
    // Flavors
    public static let predefinedFlavors: [Trait] = [
        Trait(name: "Citrus", emoji: "🍊", type: .flavor, color: ColorData(color: .orange)),
        Trait(name: "Lemon", emoji: "🍋", type: .flavor, color: ColorData(color: .yellow)),
        Trait(name: "Lime", emoji: "🍈", type: .flavor, color: ColorData(color: .green)),
        Trait(name: "Grapefruit", emoji: "🍊", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Pineapple", emoji: "🍍", type: .flavor, color: ColorData(color: .yellow)),
        Trait(name: "Berry", emoji: "🍓", type: .flavor, color: ColorData(color: .pink)),
        Trait(name: "Blueberry", emoji: "🫐", type: .flavor, color: ColorData(color: .indigo)),
        Trait(name: "Strawberry", emoji: "🍓", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Grape", emoji: "🍇", type: .flavor, color: ColorData(color: .purple)),
        Trait(name: "Cherry", emoji: "🍒", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Mango", emoji: "🥭", type: .flavor, color: ColorData(color: .orange)),
        Trait(name: "Apple", emoji: "🍏", type: .flavor, color: ColorData(color: .green)),
        Trait(name: "Peach", emoji: "🍑", type: .flavor, color: ColorData(color: .orange)),
        Trait(name: "Watermelon", emoji: "🍉", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Banana", emoji: "🍌", type: .flavor, color: ColorData(color: .yellow)),
        Trait(name: "Tropical", emoji: "🌴", type: .flavor, color: ColorData(color: .orange)),
        Trait(name: "Mint", emoji: "🌿", type: .flavor, color: ColorData(color: .green)),
        Trait(name: "Herbal", emoji: "🍃", type: .flavor, color: ColorData(color: .green)),
        Trait(name: "Pine", emoji: "🌲", type: .flavor, color: ColorData(color: .green)),
        Trait(name: "Earthy", emoji: "🌍", type: .flavor, color: ColorData(color: .brown)),
        Trait(name: "Wood", emoji: "🪵", type: .flavor, color: ColorData(color: .brown)),
        Trait(name: "Diesel", emoji: "⛽️", type: .flavor, color: ColorData(color: .gray)),
        Trait(name: "Skunk", emoji: "🦨", type: .flavor, color: ColorData(color: .gray)),
        Trait(name: "Cheese", emoji: "🧀", type: .flavor, color: ColorData(color: .yellow)),
        Trait(name: "Spicy", emoji: "🌶️", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Pepper", emoji: "🌶️", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Vanilla", emoji: "🍦", type: .flavor, color: ColorData(color: .white)),
        Trait(name: "Chocolate", emoji: "🍫", type: .flavor, color: ColorData(color: .brown)),
        Trait(name: "Coffee", emoji: "☕️", type: .flavor, color: ColorData(color: .brown)),
        Trait(name: "Nutty", emoji: "🥜", type: .flavor, color: ColorData(color: .brown)),
        Trait(name: "Caramel", emoji: "🍬", type: .flavor, color: ColorData(color: .orange)),
        Trait(name: "Butter", emoji: "🧈", type: .flavor, color: ColorData(color: .yellow)),
        Trait(name: "Honey", emoji: "🍯", type: .flavor, color: ColorData(color: .orange)),
        Trait(name: "Lavender", emoji: "🌸", type: .flavor, color: ColorData(color: .purple)),
        Trait(name: "Rose", emoji: "🌹", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Floral", emoji: "🌺", type: .flavor, color: ColorData(color: .pink)),
        Trait(name: "Sweet", emoji: "🍬", type: .flavor, color: ColorData(color: .pink)),
        Trait(name: "Spicy/Herbal", emoji: "🌶️", type: .flavor, color: ColorData(color: .red)),
        Trait(name: "Musky", emoji: "🪶", type: .flavor, color: ColorData(color: .gray)),
        Trait(name: "Sour", emoji: "🍋", type: .flavor, color: ColorData(color: .yellow)),
        Trait(name: "Creamy", emoji: "🥛", type: .flavor, color: ColorData(color: .white))
    ]
    
    // Moods
    public static let predefinedMoods: [Trait] = [
        Trait(name: "Very Negative", type: .mood, color: ColorData(color: .red)),
        Trait(name: "Negative", type: .mood, color: ColorData(color: .yellow)),
        Trait(name: "Neutral", type: .mood, color: ColorData(color: .white)),
        Trait(name: "Positive", type: .mood, color: ColorData(color: .blue)),
        Trait(name: "Very Positive", type: .mood, color: ColorData(color: .green))
    ]
}
