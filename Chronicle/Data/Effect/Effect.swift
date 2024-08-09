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
    @Relationship(inverse: \ExperienceEffect.effect)
    public var experiences: [ExperienceEffect]
    
    init(name: String, emoji: String, experiences: [ExperienceEffect] = []) {
        self.name = name
        self.emoji = emoji
        self.experiences = experiences
    }
}

