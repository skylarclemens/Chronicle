//
//  ExperienceFlavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

@Model public class ExperienceFlavor {
    public var flavor: Flavor
    public var experience: Experience
    public var intensity: Int
    
    init(flavor: Flavor, experience: Experience, intensity: Int) {
        self.flavor = flavor
        self.experience = experience
        self.intensity = intensity
    }
}
