//
//  ItemFlavor.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import Foundation
import SwiftData

@Model public class ItemFlavor {
    public var flavor: Flavor
    public var item: Item?
    public var averageIntensity: Double
    
    init(flavor: Flavor, item: Item? = nil, averageIntensity: Double = 0.0) {
        self.flavor = flavor
        self.item = item
        self.averageIntensity = averageIntensity
    }
}
