//
//  ExperienceEffect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class ExperienceEffect {
    public var effect: Effect
    public var experience: Experience
    public var intensity: Int
    
    init(effect: Effect, experience: Experience, intensity: Int) {
        self.effect = effect
        self.experience = experience
        self.intensity = intensity
    }
}
