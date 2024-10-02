//
//  AnalyticsListView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/26/24.
//

import SwiftUI
import SwiftData

struct AnalyticsListView: View {
    var items: [Item]
    var sessions: [Session]
    var strains: [Strain]
    @Binding var filter: DateFilter
    
    var filteredSessions: [Session] {
        let (startDate, endDate) = filter.dateRange()
        return sessions.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    var body: some View {
        VStack(spacing: 16) {
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
                .background(.thickMaterial,
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
                .background(.thickMaterial,
                            in: RoundedRectangle(cornerRadius: 12))
            }
            UsagePatternsView(sessions: filteredSessions, filter: $filter)
            MoodAnalyticsView(sessions: filteredSessions, filter: $filter)
        }
        .padding(.vertical)
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
    NavigationStack {
        ScrollView {
            VStack {
                Picker("Date Range", selection: $filter) {
                    ForEach(DateFilter.allCases, id: \.self) { filterSelection in
                        Text(filterSelection.rawValue.localizedCapitalized).tag(filterSelection)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                AnalyticsListView(items: [SampleData.shared.item], sessions: SampleData.shared.randomDatesSessions, strains: [SampleData.shared.strain], filter: $filter)
            }
            .padding(.horizontal)
        }
        .background(
            BackgroundView()
        )
    }
    .modelContainer(SampleData.shared.container)
}
