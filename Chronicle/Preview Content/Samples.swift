//
//  ItemSamples.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/14/24.
//

import Foundation
import UIKit

extension Item {
    static var sampleItem: Item {
        let sample = Item(name: "Blue Dream", type: .edible)
        sample.brand = "Test Brand"
        sample.effects = [
            ItemEffect(effect: Effect.predefinedEffects[0], count: 1, totalIntensity: 8),
            ItemEffect(effect: Effect.predefinedEffects[1], count: 1, totalIntensity: 6),
            ItemEffect(effect: Effect.predefinedEffects[40], count: 1, totalIntensity: 5)
        ]
        sample.flavors = [
            ItemFlavor(flavor: Flavor.predefinedFlavors[0], count: 1),
            ItemFlavor(flavor: Flavor.predefinedFlavors[1], count: 1)
        ]
        sample.composition = [
            Cannabinoid(name: "THC", value: 0.99),
            Cannabinoid(name: "CBD", value: 0.99),
            Cannabinoid(name: "CBG", value: 0.99),
        ]
        sample.terpenes = [
            Terpene.predefinedTerpenes[0],
            Terpene.predefinedTerpenes[1]
        ]
        sample.strain = Strain(name: "Blue Dream", type: .hybrid)
        let session = Session(title: "Test sesh")
        session.effects = [
            SessionEffect(effect: Effect.predefinedEffects[0], intensity: 8),
            SessionEffect(effect: Effect.predefinedEffects[1], intensity: 6),
            SessionEffect(effect: Effect.predefinedEffects[40], intensity: 5)
        ]
        session.flavors = [
            SessionFlavor(flavor: Flavor.predefinedFlavors[0]),
            SessionFlavor(flavor: Flavor.predefinedFlavors[1])
        ]
        session.notes = "Yay"
        sample.sessions.append(session)
        
        let imageData = UIImage(named: "edibles-jar")?.pngData()
        let imageData2 = UIImage(named: "pre-roll")?.pngData()
        
        if let imageData, let imageData2 {
            sample.imagesData = [imageData, imageData2]
        }
        
        return sample
    }
    
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
