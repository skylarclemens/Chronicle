//
//  SimpleAnalyticsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/30/24.
//

import SwiftUI
import SwiftData

struct SimpleAnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var activeTab: AppTab
    @Query var items: [Item]
    @Query var sessions: [Session]
    @Query var strains: [Strain]
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                activeTab = AppTab.journal
            } label: {
                SimpleAnalyticsDataView(
                    iconName: "rectangle.stack.fill",
                    iconColor: .primary,
                    analyticsDetails: "Total Sessions",
                    numberData: totalSessions)
            }
            .buttonStyle(.plain)
            Divider()
            Button {
                activeTab = AppTab.analytics
            } label: {
                SimpleAnalyticsDataView(
                    iconName: "theatermasks.fill",
                    iconColor: .purple,
                    analyticsDetails: "Most Common Mood",
                    stringData: mostCommonMood)
            }
            .buttonStyle(.plain)
            Divider()
            Button {
                activeTab = AppTab.inventory
            } label: {
                SimpleAnalyticsDataView(
                    iconName: "leaf.fill",
                    iconColor: .green,
                    analyticsDetails: "Most Used Item",
                    stringData: mostUsedItem)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .frame(maxHeight: 60)
    }
    
    /// Total number of sessions logged
    private var totalSessions: Int {
        sessions.count
    }
    
    /// Most common mood across all items
    private var mostCommonMood: String {
        let moodCounts = sessions.compactMap { $0.mood }.reduce(into: [:]) { counts, mood in
            counts[mood.type.label, default: 0] += 1
        }
        return moodCounts.max(by: { $0.value < $1.value })?.key ?? "None"
    }
    
    /// Most used item
    private var mostUsedItem: String {
        let itemCounts = sessions.compactMap { $0.item }.reduce(into: [:]) { counts, item in
            counts[item.name, default: 0] += 1
        }
        return itemCounts.max(by: { $0.value < $1.value })?.key ?? "None"
    }
}

struct SimpleAnalyticsDataView: View {
    let iconName: String
    let iconColor: Color
    var analyticsDetails: String
    var stringData: String?
    var numberData: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundStyle(iconColor.opacity(0.5))
                if let numberData {
                    Text(numberData, format: .number)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                } else if let stringData {
                    Text(stringData)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                }
            }
            Text(analyticsDetails)
                .font(.caption2)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                
        }
        .frame(minWidth: .zero, maxWidth: 115, alignment: .leading)
        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable @State var activeTab: AppTab = .dashboard
    
    SimpleAnalyticsView(activeTab: $activeTab)
        .modelContainer(SampleData.shared.container)
}
