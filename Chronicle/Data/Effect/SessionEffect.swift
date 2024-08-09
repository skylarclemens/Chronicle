//
//  ExperienceEffect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class SessionEffect {
    public var effect: Effect
    public var session: Session
    public var intensity: Int
    
    init(effect: Effect, session: Session, intensity: Int) {
        self.effect = effect
        self.session = session
        self.intensity = intensity
    }
}
