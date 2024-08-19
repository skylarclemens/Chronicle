//
//  ItemSamples.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/14/24.
//

import Foundation

extension Item {
    static var sampleItems: [Item] {
        [
            Item(name: "Blue Dream", strain: Strain.sampleStrains[0], type: .edible, amount: 1.0),
            Item(name: "Wedding Cake", strain: Strain.sampleStrains[1], type: .flower, amount: 2.0),
        ]
    }
}

extension Strain {
    static var sampleStrains: [Strain] {
        [
            Strain(name: "Blue Dream", type: .hybrid, desc: "test"),
            Strain(name: "Wedding Cake", type: .hybrid, desc: "test")
        ]
    }
}
