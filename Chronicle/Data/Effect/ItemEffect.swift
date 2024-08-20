//
//  ItemEffect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import Foundation
import SwiftData

@Model public class ItemEffect {
    public var effect: Effect
    public var item: Item?
    public var averageIntensity: Double
    
    init(effect: Effect, item: Item? = nil, averageIntensity: Double = 0.0) {
        self.effect = effect
        self.item = item
        self.averageIntensity = averageIntensity
    }
}
