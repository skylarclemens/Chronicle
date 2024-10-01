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
    
    @State var selectedDate: Date = Date()

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2")
                }
            JournalView(selectedDate: $selectedDate)
                .tabItem {
                    Label("Journal", systemImage: "book")
                }
            InventoryView()
                .tabItem {
                    Label("Stash", systemImage: "tray")
                }
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.xaxis")
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
