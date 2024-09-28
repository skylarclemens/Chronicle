//
//  AnalyticsListView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/26/24.
//

import SwiftUI
import SwiftData

struct AnalyticsListView: View {
    @Binding var filter: DateFilter
    
    var body: some View {
        VStack {
            UsagePatternsView(filter: $filter)
                .padding(.vertical)
        }
    }
}

#Preview {
    @Previewable @State var filter: DateFilter = .week
    NavigationStack {
        VStack {
            Picker("Date Range", selection: $filter) {
                ForEach(DateFilter.allCases, id: \.self) { filterSelection in
                    Text(filterSelection.rawValue.localizedCapitalized).tag(filterSelection)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            AnalyticsListView(filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}
