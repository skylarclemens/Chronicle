//
//  ExperienceEffect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class SessionEffect {
    @Attribute(.unique) public var id: UUID
    public var effect: Effect
    public var session: Session?
    public var intensity: Int
    
    init(id: UUID = UUID(), effect: Effect, session: Session? = nil, intensity: Int) {
        self.id = id
        self.effect = effect
        self.session = session
        self.intensity = intensity
    }
}
