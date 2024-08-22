//
//  ChronicleApp.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import SwiftUI
import SwiftData

@main
struct ChronicleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SharedModelContainer.create())
    }
}
