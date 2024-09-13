//
//  Flavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import Foundation
import SwiftUICore

public struct Flavor {
    var name: String
    var emoji: String?
    var color: Color
    
    init(name: String, emoji: String? = nil, color: Color) {
        self.name = name
        self.emoji = emoji
        self.color = color
    }
}

extension Flavor {
    public static let predefinedFlavors: [Flavor] = [
        Flavor(name: "Citrus", emoji: "🍊", color: .orange),
        Flavor(name: "Lemon", emoji: "🍋", color: .yellow),
        Flavor(name: "Lime", emoji: "🍈", color: .green),
        Flavor(name: "Grapefruit", emoji: "🍊", color: .red),
        Flavor(name: "Pineapple", emoji: "🍍", color: .yellow),
        Flavor(name: "Berry", emoji: "🍓", color: .pink),
        Flavor(name: "Blueberry", emoji: "🫐", color: .indigo),
        Flavor(name: "Strawberry", emoji: "🍓", color: .red),
        Flavor(name: "Grape", emoji: "🍇", color: .purple),
        Flavor(name: "Cherry", emoji: "🍒", color: .red),
        Flavor(name: "Mango", emoji: "🥭", color: .orange),
        Flavor(name: "Apple", emoji: "🍏", color: .green),
        Flavor(name: "Peach", emoji: "🍑", color: .orange),
        Flavor(name: "Watermelon", emoji: "🍉", color: .red),
        Flavor(name: "Banana", emoji: "🍌", color: .yellow),
        Flavor(name: "Tropical", emoji: "🌴", color: .orange),
        Flavor(name: "Mint", emoji: "🌿", color: .green),
        Flavor(name: "Herbal", emoji: "🍃", color: .green),
        Flavor(name: "Pine", emoji: "🌲", color: .green),
        Flavor(name: "Earthy", emoji: "🌍", color: .brown),
        Flavor(name: "Wood", emoji: "🪵", color: .brown),
        Flavor(name: "Diesel", emoji: "⛽️", color: .gray),
        Flavor(name: "Skunk", emoji: "🦨", color: .gray),
        Flavor(name: "Cheese", emoji: "🧀", color: .yellow),
        Flavor(name: "Spicy", emoji: "🌶️", color: .red),
        Flavor(name: "Pepper", emoji: "🌶️", color: .red),
        Flavor(name: "Vanilla", emoji: "🍦", color: .white),
        Flavor(name: "Chocolate", emoji: "🍫", color: .brown),
        Flavor(name: "Coffee", emoji: "☕️", color: .brown),
        Flavor(name: "Nutty", emoji: "🥜", color: .brown),
        Flavor(name: "Caramel", emoji: "🍬", color: .orange),
        Flavor(name: "Butter", emoji: "🧈", color: .yellow),
        Flavor(name: "Honey", emoji: "🍯", color: .orange),
        Flavor(name: "Lavender", emoji: "🌸", color: .purple),
        Flavor(name: "Rose", emoji: "🌹", color: .red),
        Flavor(name: "Floral", emoji: "🌺", color: .pink),
        Flavor(name: "Sweet", emoji: "🍬", color: .pink),
        Flavor(name: "Spicy/Herbal", emoji: "🌶️", color: .red),
        Flavor(name: "Musky", emoji: "🪶", color: .gray),
        Flavor(name: "Sour", emoji: "🍋", color: .yellow),
        Flavor(name: "Creamy", emoji: "🥛", color: .white)
    ]
}
