//
//  ModelPreview.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData

struct ModelPreview {
    let container: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: Schema([Item.self, Strain.self, Session.self, Effect.self, SessionEffect.self, Flavor.self, SessionFlavor.self]), configurations: config)
        } catch {
            fatalError("Failed to create preview container: \(error.localizedDescription)")
        }
    }
    
    func addExamples() {
        Task { @MainActor in
            let strain1 = Strain(name: "Blue Dream", type: "Hybrid", desc: "test")
            let strain2 = Strain(name: "Wedding Cake", type: "Hybrid", desc: "test")
            
            container.mainContext.insert(strain1)
            container.mainContext.insert(strain2)
            
            let item1 = Item(name: "Item 1", strain: strain1, type: .concentrate, amount: 1.0)
            let item2 = Item(name: "Item 2", strain: strain2, type: .flower, amount: 2.0)
            
            container.mainContext.insert(item1)
            container.mainContext.insert(item2)
            
            let session1 = Session(item: item1, consumptionMethod: "Smoke")
            
            container.mainContext.insert(session1)
        }
    }
}
