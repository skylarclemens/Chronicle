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
            Trait.self,
            ItemTrait.self,
            SessionTrait.self
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
            session.imagesData = [Item.sampleImages.randomElement()!]
            container.mainContext.insert(session)
        }
        
        for effect in Trait.predefinedEffects {
            container.mainContext.insert(effect)
        }
        
        for flavor in Trait.predefinedFlavors {
            container.mainContext.insert(flavor)
        }
        
        for itemTrait in ItemTrait.sampleData {
            container.mainContext.insert(itemTrait)
        }
        
        for sessionTrait in SessionTrait.sampleData {
            container.mainContext.insert(sessionTrait)
        }
        
        for strain in Strain.sampleData {
            container.mainContext.insert(strain)
        }
        
        item.strain = strain
        item.sessions.append(session)
        session.item = item
        sessionTrait.session = session
        sessionTrait.itemTrait = itemTrait
        itemTrait.item = item
        itemTrait.sessionTraits.append(sessionTrait)
        
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
    
    var itemTrait: ItemTrait {
        ItemTrait.sampleData[0]
    }
    
    var sessionTrait: SessionTrait {
        SessionTrait.sampleData[0]
    }
}
