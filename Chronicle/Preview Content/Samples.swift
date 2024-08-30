//
//  ItemSamples.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/14/24.
//

import Foundation
import UIKit

extension Item {
    static let sampleData: [Item] = [
        Item(name: "Blue Dream", type: .edible, amount: 1.0, favorite: true),
        Item(name: "Wedding Cake", type: .flower, amount: 2.0),
    ]
    
    static var sampleImages: [Data] {
        var images: [Data] = []
        let imageData = UIImage(named: "edibles-jar")?.pngData()
        let imageData2 = UIImage(named: "pre-roll")?.pngData()

        if let imageData, let imageData2 {
            images.append(imageData)
            images.append(imageData2)
        }
        
        return images
    }
}

extension Session {
    static let sampleData: [Session] = [
        Session(title: "Test sesh", favorite: true),
        Session(title: "2nd test sesh")
    ]
}

extension Strain {
    static let sampleData: [Strain] = [
        Strain(name: "Blue Dream", type: .hybrid, desc: "test"),
        Strain(name: "Wedding Cake", type: .hybrid, desc: "test")
    ]
}

extension ItemTrait {
    static let sampleData: [ItemTrait] = [
        ItemTrait(trait: Trait.predefinedEffects[4]),
        ItemTrait(trait: Trait.predefinedEffects[5]),
        ItemTrait(trait: Trait.predefinedEffects[42]),
        ItemTrait(trait: Trait.predefinedFlavors[4]),
        ItemTrait(trait: Trait.predefinedFlavors[6])
    ]
}

extension SessionTrait {
    static let sampleData: [SessionTrait] = [
        SessionTrait(itemTrait: ItemTrait.sampleData[0], intensity: 4),
        SessionTrait(itemTrait: ItemTrait.sampleData[1], intensity: 8),
        SessionTrait(itemTrait: ItemTrait.sampleData[2], intensity: 10),
        SessionTrait(itemTrait: ItemTrait.sampleData[3]),
        SessionTrait(itemTrait: ItemTrait.sampleData[4])
    ]
}
