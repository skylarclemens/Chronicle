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
            Trait.self,
            ItemTrait.self,
            SessionTrait.self
        ])
        let configuration = ModelConfiguration()

        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
            
            Trait.predefinedEffects.forEach { container.mainContext.insert($0) }
            Trait.predefinedFlavors.forEach { container.mainContext.insert($0) }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
