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
    public var color: String?
    
    init(name: String, emoji: String, color: String? = nil) {
        self.name = name
        self.emoji = emoji
        self.color = color
    }
}

