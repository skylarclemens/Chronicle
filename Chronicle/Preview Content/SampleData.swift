//
//  SampleData.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let container: ModelContainer
    
    var context: ModelContext {
        container.mainContext
    }
    
    private init() {
        let schema = Schema([
            Item.self,
            Session.self,
            Strain.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        do {
            container = try ModelContainer(for: schema, configurations: config)
            
            addData()
        } catch {
            fatalError("Failed to create preview container: \(error.localizedDescription)")
        }
    }
    
    func addData() {
        for item in Item.sampleData {
            item.imagesData = [Item.sampleImages.randomElement()!]
            container.mainContext.insert(item)
        }
        
        for session in Session.sampleData {
            session.imagesData = [Item.sampleImages.randomElement()!, Item.sampleImages.randomElement()!]
            container.mainContext.insert(session)
        }
        
        for accessory in Accessory.sampleData {
            container.mainContext.insert(accessory)
        }
        
        for mood in Mood.sampleData {
            container.mainContext.insert(mood)
        }
        
        for strain in Strain.sampleData {
            container.mainContext.insert(strain)
        }
        
        for purchase in Purchase.sampleData {
            container.mainContext.insert(purchase)
        }
        
        for inventorySnapshot in InventorySnapshot.sampleData {
            container.mainContext.insert(inventorySnapshot)
        }
        
        for inventoryTransaction in InventoryTransaction.sampleData {
            container.mainContext.insert(inventoryTransaction)
        }
        
        for tag in Tag.sampleData {
            container.mainContext.insert(tag)
        }
        
        for wellness in Wellness.predefinedData {
            container.mainContext.insert(wellness)
        }
        
        for wellnessEntry in WellnessEntry.sampleData {
            container.mainContext.insert(wellnessEntry)
        }
        
        for activity in Activity.predefinedData {
            container.mainContext.insert(activity)
        }
        
        for effect in Effect.predefinedData {
            container.mainContext.insert(effect)
        }
        
        for randomDateSession in Session.randomDatesSampleData {
            randomDateSession.item = item
            container.mainContext.insert(session)
        }
        
        item.strain = strain
        item.sessions?.append(session)
        item.tags?.append(tag)
        item.tags?.append(allTags[2])
        
        inventoryTransaction.purchase = purchase
        item.transactions?.append(contentsOf: inventoryTransactions)
        inventorySnapshot.item = item
        inventorySnapshot2.item = item
        item.snapshots?.append(inventorySnapshot)
        item.snapshots?.append(inventorySnapshot2)
        
        session.item = item
        session.mood = mood
        session.transaction = consumptionInventoryTransaction
        session.locationInfo = LocationInfo(name: "Sample Location", latitude: 40.7127, longitude: -74.0059)
        if let sampleAudio = NSDataAsset(name: "sample")?.data {
            session.audioData = sampleAudio
        }
        session.tags?.append(tag2)
        session.accessories?.append(accessory)
        accessory.sessions?.append(session)
        wellnessEntry.wellness = wellness
        wellnessEntry.session = session
        session.wellnessEntries?.append(wellnessEntry)
        activity.sessions?.append(session)
        activity2.sessions?.append(session)
        session.activities?.append(activity)
        session.activities?.append(activity2)
        effect.sessions?.append(session)
        effect2.sessions?.append(session)
        session.effects?.append(effect)
        session.effects?.append(effect2)
        
        do {
            try context.save()
        } catch {
            print("Sample data context failed to save.")
        }
    }
    
    var item: Item {
        Item.sampleData[0]
    }
    
    var session: Session {
        Session.sampleData[0]
    }
    
    var accessory: Accessory {
        Accessory.sampleData[0]
    }
    
    var randomDatesSessions: [Session] {
        Session.randomDatesSampleData
    }
    
    var strain: Strain {
        Strain.sampleData[0]
    }
    
    var mood: Mood {
        Mood.sampleData[0]
    }
        
    var purchase: Purchase {
        Purchase.sampleData[0]
    }
    
    var inventoryTransaction: InventoryTransaction {
        InventoryTransaction.sampleData[0]
    }
    
    var consumptionInventoryTransaction: InventoryTransaction {
        InventoryTransaction.sampleData[1]
    }
    
    var inventoryTransactions: [InventoryTransaction] {
        InventoryTransaction.sampleData
    }
    
    var inventorySnapshot: InventorySnapshot {
        InventorySnapshot.sampleData[0]
    }
    
    var inventorySnapshot2: InventorySnapshot {
        InventorySnapshot.sampleData[1]
    }
    
    var wellness: Wellness{
        Wellness.predefinedData[0]
    }
    
    var wellnessEntry: WellnessEntry {
        WellnessEntry.sampleData[0]
    }
    
    var activity: Activity {
        Activity.predefinedData[10]
    }
    
    var activity2: Activity {
        Activity.predefinedData[12]
    }
    
    var effect: Effect {
        Effect.predefinedData[2]
    }
    
    var effect2: Effect {
        Effect.predefinedData[14]
    }
    
    var tag: Tag {
        Tag.sampleData[0]
    }
    
    var tag2: Tag {
        Tag.sampleData[1]
    }
    
    var allTags: [Tag] {
        Tag.sampleData
    }
}
