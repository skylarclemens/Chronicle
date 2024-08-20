//
//  ContentView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                }
            JournalView()
                .tabItem {
                    Image(systemName: "book")
                }
            InventoryView()
                .tabItem {
                    Image(systemName: "tray")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addExamples(sampleItems: Item.sampleItems)
    
    return ContentView()
        .modelContainer(modelPreview.container)
}
