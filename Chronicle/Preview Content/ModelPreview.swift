//
//  ModelPreview.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/7/24.
//

import Foundation
import SwiftData
import SwiftUI

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
    
    func addExamples(sampleItems: [Item]) {
        Task { @MainActor in
            let imageData = UIImage(named: "edibles-jar")?.pngData()
            let imageData2 = UIImage(named: "pre-roll")?.pngData()
            
            sampleItems.forEach { item in
                if let imageData {
                    item.imagesData = [imageData]
                }
                container.mainContext.insert(item)
                if let strain = item.strain {
                    container.mainContext.insert(strain)
                }
            }
            
            let session1 = Session(item: sampleItems[0])
            if let imageData2 {
                session1.imagesData = [imageData2]
            }
            session1.title = "Example sesh"
            session1.notes = "Test"
            container.mainContext.insert(session1)
        }
    }
}
