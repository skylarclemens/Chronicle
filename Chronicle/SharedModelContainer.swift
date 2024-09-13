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
        ])
        let configuration = ModelConfiguration()

        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
