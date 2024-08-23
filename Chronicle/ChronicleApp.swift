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
    @State private var imageViewManager = ImageViewManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(imageViewManager)
        }
        .modelContainer(SharedModelContainer.create())
    }
}
