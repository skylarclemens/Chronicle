//
//  SelectedItemAnalyticsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/15/24.
//

import SwiftUI
import Charts

struct SelectedItemAnalyticsView: View {
    @Binding var item: Item?
    @Binding var filter: DateFilter
    
    var sessions: [Session] {
        let (startDate, endDate) = filter.dateRange()
        return item?.sessions?.filter { $0.date >= startDate && $0.date <= endDate } ?? []
    }
    
    var body: some View {
        if let item {
            VStack(alignment: .leading, spacing: 24) {
                UsagePatternsView(sessions: sessions, filter: $filter)
                    .padding(.horizontal)
                MoodAnalyticsView(item: item, sessions: sessions, filter: $filter)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    @Previewable @State var item: Item? = SampleData.shared.item
    @Previewable @State var filter: DateFilter = .week
    
    NavigationStack {
        ScrollView {
            SelectedItemAnalyticsView(item: $item, filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}
