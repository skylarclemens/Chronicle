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
                    Label("Dashboard", systemImage: "square.grid.2x2")
                        .labelStyle(.iconOnly)
                }
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                        .labelStyle(.iconOnly)
                }
            InventoryView()
                .tabItem {
                    Label("Stash", systemImage: "tray")
                        .labelStyle(.iconOnly)
                }
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.xaxis")
                        .labelStyle(.iconOnly)
                }
        }
        .colorSchemeStyle()
        .overlay {
            if imageViewManager.showImageViewer {
                ImageViewerView()
            }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
