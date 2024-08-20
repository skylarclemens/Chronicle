//
//  ItemEffect.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import Foundation
import SwiftData

@Model public class ItemEffect {
    @Attribute(.unique) public var id: UUID
    public var effect: Effect
    public var item: Item?
    public var count: Int
    public var totalIntensity: Int
    var averageIntensity: Double {
        return Double(totalIntensity) / Double(count)
    }
    
    init(id: UUID = UUID(), effect: Effect, item: Item? = nil, count: Int = 1, totalIntensity: Int = 0) {
        self.id = id
        self.effect = effect
        self.item = item
        self.count = count
        self.totalIntensity = totalIntensity
    }
}
