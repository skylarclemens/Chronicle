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
    
    @State var activeTab: AppTab = .dashboard
    @State var selectedDate: Date = Date()

    var body: some View {
        TabView(selection: $activeTab) {
            DashboardView(activeTab: $activeTab)
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2")
                }
                .tag(AppTab.dashboard)
            JournalView(selectedDate: $selectedDate)
                .tabItem {
                    Label("Journal", systemImage: "book")
                }
                .tag(AppTab.journal)
            InventoryView()
                .tabItem {
                    Label("Stash", systemImage: "tray")
                }
                .tag(AppTab.inventory)
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.xaxis")
                }
                .tag(AppTab.analytics)
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

public enum AppTab {
    case dashboard, journal, inventory, analytics
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
