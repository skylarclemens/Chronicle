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
        Item(name: "Blue Dream", type: .edible, selectedUnits: ItemUnits(amount: .grams, dosage: .grams), favorite: true),
        Item(name: "Wedding Cake", type: .flower, selectedUnits: ItemUnits(amount: .grams, dosage: .grams))
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
    
    static var randomDatesSampleData: [Session] {
        let calendar = Calendar.current
        let currentDate = Date()
        let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: currentDate)!
        
        return (0..<50).map { index in
            let randomDate = Date.random(in: threeMonthsAgo...currentDate)
            
            return Session(
                id: UUID(),
                createdAt: randomDate,
                title: "Session \(index + 1)",
                date: randomDate,
                duration: TimeInterval.random(in: 600...3600),  // 10 minutes to 1 hour
                notes: "Sample session notes for session \(index + 1)",
                favorite: Bool.random(),
                transaction: InventoryTransaction(
                    type: .consumption,
                    amount: Amount(value: Double.random(in: -3.0..<0.0), unit: AcceptedUnit.allCases.randomElement()!)
                ),
                mood: Mood(
                    type: MoodType.allCases.randomElement()!,
                    valence: Double.random(in: -1.0...1.0),
                    emotions: Array(Emotion.initialEmotions.shuffled().prefix(3))
                )
            )
        }.sorted { $0.date < $1.date }
    }
}

extension Accessory {
    static let sampleData: [Accessory] = [
        Accessory(name: "My Bong", type: .bong, purchase: Purchase(date: Date(), price: 100), brand: "Brand", favorite: true),
        Accessory(name: "Pipe", type: .pipe, purchase: Purchase(date: Date(), price: 20), brand: "Brand")
    ]
}

extension Strain {
    static let sampleData: [Strain] = [
        Strain(name: "Blue Dream", type: .hybrid, desc: "test", favorite: true),
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
        Purchase(date: Date(), price: 20.0, location: LocationInfo(name: "Sample Location", latitude: 40.7127, longitude: -74.0059))
    ]
}

extension InventoryTransaction {
    static let sampleData: [InventoryTransaction] = [
        InventoryTransaction(type: .set, amount: Amount(value: 3.5, unit: .grams), date: Calendar.autoupdatingCurrent.date(byAdding: .month, value: -3, to: Date())!, updateInventory: false),
        InventoryTransaction(type: .consumption, amount: Amount(value: -1.5, unit: .grams), date: Calendar.autoupdatingCurrent.date(byAdding: .month, value: -2, to: Date())!),
        InventoryTransaction(type: .set, amount: Amount(value: 10, unit: .grams), date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: -2, to: Date())!, updateInventory: false),
        InventoryTransaction(type: .consumption, amount: Amount(value: -1.0, unit: .grams), date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: Date())!)
    ]
}

extension InventorySnapshot {
    static let sampleData: [InventorySnapshot] = [
        InventorySnapshot(date: Calendar.autoupdatingCurrent.date(byAdding: .month, value: -3, to: Date())!, amount: Amount(value: 3.5, unit: .grams)),
        InventorySnapshot(date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: -2, to: Date())!, amount: Amount(value: 10, unit: .grams))
    ]
}

extension Tag {
    static let sampleData: [Tag] = [
        Tag(name: "Top Shelf"),
        Tag(name: "With Friends"),
        Tag(name: "Outdoors"),
    ]
}
