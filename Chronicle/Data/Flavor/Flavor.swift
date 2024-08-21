//
//  Flavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model public class Flavor {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var emoji: String
    public var color: ColorData
    
    init(id: UUID = UUID(), name: String, emoji: String, color: ColorData = ColorData(color: .green)) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
    }
    
    public static let predefinedFlavors: [Flavor] = [
        Flavor(name: "Citrus", emoji: "🍊", color: ColorData(color: .orange)),
        Flavor(name: "Lemon", emoji: "🍋", color: ColorData(color: .yellow)),
        Flavor(name: "Lime", emoji: "🍈", color: ColorData(color: .green)),
        Flavor(name: "Grapefruit", emoji: "🍊", color: ColorData(color: .red)),
        Flavor(name: "Pineapple", emoji: "🍍", color: ColorData(color: .yellow)),
        Flavor(name: "Berry", emoji: "🍓", color: ColorData(color: .pink)),
        Flavor(name: "Blueberry", emoji: "🫐", color: ColorData(color: .indigo)),
        Flavor(name: "Strawberry", emoji: "🍓", color: ColorData(color: .red)),
        Flavor(name: "Grape", emoji: "🍇", color: ColorData(color: .purple)),
        Flavor(name: "Cherry", emoji: "🍒", color: ColorData(color: .red)),
        Flavor(name: "Mango", emoji: "🥭", color: ColorData(color: .orange)),
        Flavor(name: "Apple", emoji: "🍏", color: ColorData(color: .green)),
        Flavor(name: "Peach", emoji: "🍑", color: ColorData(color: .orange)),
        Flavor(name: "Watermelon", emoji: "🍉", color: ColorData(color: .red)),
        Flavor(name: "Banana", emoji: "🍌", color: ColorData(color: .yellow)),
        Flavor(name: "Tropical", emoji: "🌴", color: ColorData(color: .orange)),
        Flavor(name: "Mint", emoji: "🌿", color: ColorData(color: .green)),
        Flavor(name: "Herbal", emoji: "🍃", color: ColorData(color: .green)),
        Flavor(name: "Pine", emoji: "🌲", color: ColorData(color: .green)),
        Flavor(name: "Earthy", emoji: "🌍", color: ColorData(color: .brown)),
        Flavor(name: "Wood", emoji: "🪵", color: ColorData(color: .brown)),
        Flavor(name: "Diesel", emoji: "⛽️", color: ColorData(color: .gray)),
        Flavor(name: "Skunk", emoji: "🦨", color: ColorData(color: .gray)),
        Flavor(name: "Cheese", emoji: "🧀", color: ColorData(color: .yellow)),
        Flavor(name: "Spicy", emoji: "🌶️", color: ColorData(color: .red)),
        Flavor(name: "Pepper", emoji: "🌶️", color: ColorData(color: .red)),
        Flavor(name: "Vanilla", emoji: "🍦", color: ColorData(color: .white)),
        Flavor(name: "Chocolate", emoji: "🍫", color: ColorData(color: .brown)),
        Flavor(name: "Coffee", emoji: "☕️", color: ColorData(color: .brown)),
        Flavor(name: "Nutty", emoji: "🥜", color: ColorData(color: .brown)),
        Flavor(name: "Caramel", emoji: "🍬", color: ColorData(color: .orange)),
        Flavor(name: "Butter", emoji: "🧈", color: ColorData(color: .yellow)),
        Flavor(name: "Honey", emoji: "🍯", color: ColorData(color: .orange)),
        Flavor(name: "Lavender", emoji: "🌸", color: ColorData(color: .purple)),
        Flavor(name: "Rose", emoji: "🌹", color: ColorData(color: .red)),
        Flavor(name: "Floral", emoji: "🌺", color: ColorData(color: .pink)),
        Flavor(name: "Sweet", emoji: "🍬", color: ColorData(color: .pink)),
        Flavor(name: "Spicy/Herbal", emoji: "🌶️", color: ColorData(color: .red)),
        Flavor(name: "Musky", emoji: "🪶", color: ColorData(color: .gray)),
        Flavor(name: "Sour", emoji: "🍋", color: ColorData(color: .yellow)),
        Flavor(name: "Creamy", emoji: "🥛", color: ColorData(color: .white))
    ]
}
