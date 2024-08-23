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
    @Environment(ImageViewManager.self) var imageViewManager

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
        .overlay {
            if imageViewManager.showImageViewer {
                ImageViewerView()
            }
        }
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addExamples(sampleItems: Item.sampleItems)
    
    return ContentView()
        .modelContainer(modelPreview.container)
        .environment(ImageViewManager())
}
