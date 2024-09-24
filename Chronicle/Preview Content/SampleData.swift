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
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
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
        
        for mood in Mood.sampleData {
            container.mainContext.insert(mood)
        }
        
        for strain in Strain.sampleData {
            container.mainContext.insert(strain)
        }
        
        for purchase in Purchase.sampleData {
            container.mainContext.insert(purchase)
        }
        
        for tag in Tag.sampleData {
            container.mainContext.insert(tag)
        }
        
        item.strain = strain
        item.sessions.append(session)
        item.purchases.append(purchase)
        item.tags.append(tag)
        item.tags.append(allTags[2])
        session.item = item
        session.mood = mood
        session.tags.append(tag2)
        
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
    
    var strain: Strain {
        Strain.sampleData[0]
    }
    
    var mood: Mood {
        Mood.sampleData[0]
    }
        
    var purchase: Purchase {
        Purchase.sampleData[0]
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
