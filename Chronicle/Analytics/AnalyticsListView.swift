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
    
    var filteredItems: [Item] {
        let (startDate, endDate) = filter.dateRange()
        return items.filter { $0.createdAt >= startDate && $0.createdAt <= endDate }
    }
    
    var filteredStrains: [Strain] {
        let (startDate, endDate) = filter.dateRange()
        return strains.filter { $0.createdAt >= startDate && $0.createdAt <= endDate }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            UsagePatternsView(sessions: filteredSessions, filter: $filter)
            ItemAnalyticsView(items: filteredItems, sessions: filteredSessions, strains: filteredStrains, filter: $filter)
            MoodAnalyticsView(sessions: filteredSessions, filter: $filter)
        }
        .padding(.vertical)
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
