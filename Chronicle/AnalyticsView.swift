//
//  AnalyticsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/26/24.
//

import SwiftUI

struct AnalyticsView: View {
    @State private var filter: DateFilter = .week
    
    var startDate: Date {
        filter.dateRange().0
    }
    
    var endDate: Date {
        filter.dateRange().1
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Picker("Date Range", selection: $filter.animation()) {
                        ForEach(DateFilter.allCases, id: \.self) { filterSelection in
                            Text(filterSelection.rawValue.localizedCapitalized).tag(filterSelection)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    dateLabel
                        .font(.callout)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                    AnalyticsListView(filter: $filter)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Analytics")
        }
    }
    
    @ViewBuilder
    var dateLabel: some View {
        switch filter {
        case .week:
            HStack(spacing: 0){
                Text(startDate.formatted(date: .abbreviated, time: .omitted))
                Text("-")
                Text(endDate.formatted(date: .abbreviated, time: .omitted))
            }
        case .month:
            Text(startDate, format: .dateTime.month(.wide).year())
        case .year:
            Text(startDate, format: .dateTime.year())
        }
    }
}

#Preview {
    AnalyticsView()
        .modelContext(SampleData.shared.context)
}
