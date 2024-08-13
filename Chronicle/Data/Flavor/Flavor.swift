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
    public var name: String
    public var emoji: String
    public var color: String?
    
    var flavorColor: Color {
        Color(color ?? "green")
    }
    
    init(name: String, emoji: String, color: String? = nil) {
        self.name = name
        self.emoji = emoji
        self.color = color
    }
    
    public static let predefinedFlavors: [Flavor] = [
        Flavor(name: "Citrus", emoji: "🍊", color: Color.orange.description),
        Flavor(name: "Lemon", emoji: "🍋", color: Color.yellow.description),
        Flavor(name: "Lime", emoji: "🍈", color: Color.green.description),
        Flavor(name: "Grapefruit", emoji: "🍊", color: Color.red.description),
        Flavor(name: "Pineapple", emoji: "🍍", color: Color.yellow.description),
        Flavor(name: "Berry", emoji: "🍓", color: Color.pink.description),
        Flavor(name: "Blueberry", emoji: "🫐", color: Color.indigo.description),
        Flavor(name: "Strawberry", emoji: "🍓", color: Color.red.description),
        Flavor(name: "Grape", emoji: "🍇", color: Color.purple.description),
        Flavor(name: "Cherry", emoji: "🍒", color: Color.red.description),
        Flavor(name: "Mango", emoji: "🥭", color: Color.orange.description),
        Flavor(name: "Apple", emoji: "🍏", color: Color.green.description),
        Flavor(name: "Peach", emoji: "🍑", color: Color.orange.description),
        Flavor(name: "Watermelon", emoji: "🍉", color: Color.red.description),
        Flavor(name: "Banana", emoji: "🍌", color: Color.yellow.description),
        Flavor(name: "Tropical", emoji: "🌴", color: Color.orange.description),
        Flavor(name: "Mint", emoji: "🌿", color: Color.green.description),
        Flavor(name: "Herbal", emoji: "🍃", color: Color.green.description),
        Flavor(name: "Pine", emoji: "🌲", color: Color.green.description),
        Flavor(name: "Earthy", emoji: "🌍", color: Color.brown.description),
        Flavor(name: "Wood", emoji: "🪵", color: Color.brown.description),
        Flavor(name: "Diesel", emoji: "⛽️", color: Color.gray.description),
        Flavor(name: "Skunk", emoji: "🦨", color: Color.gray.description),
        Flavor(name: "Cheese", emoji: "🧀", color: Color.yellow.description),
        Flavor(name: "Spicy", emoji: "🌶️", color: Color.red.description),
        Flavor(name: "Pepper", emoji: "🌶️", color: Color.red.description),
        Flavor(name: "Vanilla", emoji: "🍦", color: Color.white.description),
        Flavor(name: "Chocolate", emoji: "🍫", color: Color.brown.description),
        Flavor(name: "Coffee", emoji: "☕️", color: Color.brown.description),
        Flavor(name: "Nutty", emoji: "🥜", color: Color.brown.description),
        Flavor(name: "Caramel", emoji: "🍬", color: Color.orange.description),
        Flavor(name: "Butter", emoji: "🧈", color: Color.yellow.description),
        Flavor(name: "Honey", emoji: "🍯", color: Color.orange.description),
        Flavor(name: "Lavender", emoji: "🌸", color: Color.purple.description),
        Flavor(name: "Rose", emoji: "🌹", color: Color.red.description),
        Flavor(name: "Floral", emoji: "🌺", color: Color.pink.description),
        Flavor(name: "Sweet", emoji: "🍬", color: Color.pink.description),
        Flavor(name: "Spicy/Herbal", emoji: "🌶️", color: Color.red.description),
        Flavor(name: "Musky", emoji: "🪶", color: Color.gray.description),
        Flavor(name: "Sour", emoji: "🍋", color: Color.yellow.description),
        Flavor(name: "Creamy", emoji: "🥛", color: Color.white.description)
    ]
}
