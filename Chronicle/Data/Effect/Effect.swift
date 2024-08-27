//
//  Effect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class Effect {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var emoji: String
    public var type: EffectType
    public var color: String?
    
    init(id: UUID = UUID(), name: String, emoji: String = "✨", type: EffectType, color: String? = nil) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.type = type
        self.color = color
    }
}
