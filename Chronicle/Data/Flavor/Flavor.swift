//
//  Flavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class Flavor {
    public var name: String
    public var emoji: String
    public var color: String?
    @Relationship(inverse: \ExperienceFlavor.flavor)
    public var experiences: [ExperienceFlavor]
    
    init(name: String, emoji: String, color: String? = nil, experiences: [ExperienceFlavor] = []) {
        self.name = name
        self.emoji = emoji
        self.color = color
        self.experiences = experiences
    }
}
