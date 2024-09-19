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
        Item(name: "Blue Dream", type: .edible, amount: Amount(value: 2.0, unit: "g"), favorite: true),
        Item(name: "Wedding Cake", type: .flower, amount: Amount(value: 2.5, unit: "g")),
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
        Session(title: "Test sesh", notes: "Hi :)", favorite: true),
        Session(title: "2nd test sesh")
    ]
}

extension Strain {
    static let sampleData: [Strain] = [
        Strain(name: "Blue Dream", type: .hybrid, desc: "test"),
        Strain(name: "Wedding Cake", type: .hybrid, desc: "test")
    ]
}

extension Mood {
    static let sampleData: [Mood] = [
        Mood(type: .positive, emotions: [Emotion.initialEmotions[0], Emotion.initialEmotions[1]]),
        Mood(type: .neutral, emotions: [Emotion.initialEmotions[3], Emotion.initialEmotions[4]]),
    ]
}

extension Purchase {
    static let sampleData: [Purchase] = [
        Purchase(date: Date(), amount: Amount(value: 3.5, unit: "g"), price: 20.0, location: "Dispensary")
    ]
}
