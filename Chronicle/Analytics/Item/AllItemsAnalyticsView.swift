//
//  AllItemsAnalyticsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/15/24.
//

import SwiftUI
import Charts

struct AllItemsAnalyticsView: View {
    var items: [Item]
    var sessions: [Session]
    var strains: [Strain]
    @Binding var filter: DateFilter
    
    var filteredItems: [Item] {
        let (startDate, endDate) = filter.dateRange()
        return items.filter { $0.createdAt >= startDate && $0.createdAt <= endDate }
    }
    
    var filteredSessions: [Session] {
        let (startDate, endDate) = filter.dateRange()
        return sessions.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    var filteredMoods: [Mood] {
        filteredSessions.compactMap { $0.mood }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mostUsedItem()?.name ?? "None")
                            .contentTransition(.interpolate)
                        Text("Most Used Item".localizedUppercase)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .fontDesign(.rounded)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mostUsedStrain() ?? "None")
                            .contentTransition(.interpolate)
                        Text("Most Used Strain".localizedUppercase)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .fontDesign(.rounded)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                }
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "rectangle.stack.fill")
                                .foregroundStyle(.primary.opacity(0.5))
                            Text(filteredSessions.count, format: .number)
                                .contentTransition(.numericText(value: Double(filteredSessions.count)))
                        }
                        Text("Total Sessions".localizedUppercase)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .fontDesign(.rounded)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "theatermasks.fill")
                                .foregroundStyle(.primary.opacity(0.5))
                            Text(filteredMoods.count, format: .number)
                                .contentTransition(.numericText(value: Double(filteredMoods.count)))
                        }
                        Text("Moods Logged".localizedUppercase)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .fontDesign(.rounded)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .animation(.default, value: sessions)
            GroupBox("Item Type Distribution") {
                ItemTypeDistributionChart(items: filteredItems)
                    .frame(height: 250)
                    .animation(.default, value: filteredItems)
            }
            .backgroundStyle(Color(.secondarySystemGroupedBackground))
        }
    }
    
    private func mostUsedStrain() -> String? {
        let strainCounts = filteredSessions.compactMap {
            $0.item?.strain?.name
        }.reduce(into: [:]) { counts, strain in
            counts[strain, default: 0] += 1
        }
        
        guard !strainCounts.isEmpty else { return nil }
        
        let maxCount = strainCounts.values.max()!
        let mostUsedStrains = strainCounts.filter { $0.value == maxCount }.keys
        
        return mostUsedStrains.min(by: { $0.lowercased() < $1.lowercased() })
    }
    
    private func mostUsedItem() -> Item? {
        let itemCounts = filteredSessions.compactMap(\.item).reduce(into: [:]) { counts, item in
            counts[item, default: 0] += 1
        }
        guard !itemCounts.isEmpty else { return nil }
        
        let maxCount = itemCounts.values.max()!
        let mostUsedItems = itemCounts.filter { $0.value == maxCount }.keys
        
        return mostUsedItems.min(by: { $0.createdAt < $1.createdAt })
    }
}

#Preview {
    @Previewable @State var filter: DateFilter = .week
    
    var filteredSessions: [Session] {
        let (startDate, endDate) = filter.dateRange()
        let data = SampleData.shared.randomDatesSessions + [SampleData.shared.session]
        return data.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    NavigationStack {
        VStack {
            AllItemsAnalyticsView(items: [SampleData.shared.item], sessions: filteredSessions, strains: [SampleData.shared.strain], filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}
