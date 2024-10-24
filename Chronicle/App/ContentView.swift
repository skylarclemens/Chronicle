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
    
    @Query var wellness: [Wellness]
    @Query var activities: [Activity]
    @Query var effects: [Effect]

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
                    Label("Trends", systemImage: "chart.bar.xaxis")
                }
                .tag(AppTab.trends)
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
        .onAppear {
            if effects.isEmpty {
                for effect in Effect.predefinedData {
                    modelContext.insert(effect)
                }
            }
            if wellness.isEmpty {
                for wellness in Wellness.predefinedData {
                    modelContext.insert(wellness)
                }
            }
            if activities.isEmpty {
                for activity in Activity.predefinedData {
                    modelContext.insert(activity)
                }
            }
            if effects.isEmpty || wellness.isEmpty || activities.isEmpty {
                do {
                    try modelContext.save()
                } catch {
                    print("Model context failed to save when adding predefined data: \(error.localizedDescription)")
                }
            }
        }
    }
}

public enum AppTab {
    case dashboard, journal, inventory, trends
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
