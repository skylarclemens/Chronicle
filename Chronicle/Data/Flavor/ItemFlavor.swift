//
//  ItemFlavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import Foundation
import SwiftData

@Model public class ItemFlavor {
    @Attribute(.unique) public var id: UUID
    public var flavor: Flavor
    public var item: Item?
    public var count: Int
    public var totalIntensity: Int
    
    init(id: UUID = UUID(), flavor: Flavor, item: Item? = nil, count: Int = 1, totalIntensity: Int = 0) {
        self.id = id
        self.flavor = flavor
        self.item = item
        self.count = count
        self.totalIntensity = totalIntensity
    }
}
