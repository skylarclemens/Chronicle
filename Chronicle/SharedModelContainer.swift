//
//  SharedModelContainer.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import Foundation
import SwiftData

actor SharedModelContainer {
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema([
            Item.self,
            Strain.self,
            Session.self,
            Effect.self,
            SessionEffect.self,
            ItemEffect.self,
            Flavor.self,
            SessionFlavor.self,
            ItemFlavor.self,
            Cannabinoid.self,
            Terpene.self
        ])
        let configuration = ModelConfiguration()

        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
            
            Effect.predefinedEffects.forEach { container.mainContext.insert($0) }
            Flavor.predefinedFlavors.forEach { container.mainContext.insert($0) }
            Terpene.predefinedTerpenes.forEach { container.mainContext.insert($0) }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
