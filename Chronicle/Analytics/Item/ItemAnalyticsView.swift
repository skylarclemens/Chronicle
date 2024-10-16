//
//  ItemAnalyticsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI
import Charts

struct ItemAnalyticsView: View {
    var items: [Item]
    var sessions: [Session]
    var strains: [Strain]
    @Binding var filter: DateFilter
    
    var body: some View {
        NavigationLink {
            ItemAnalyticsDetailsView(items: items, sessions: sessions, strains: strains, filter: $filter)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.green.opacity(0.5))
                    Text("Items")
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                        .foregroundStyle(.tertiary)
                }
                Spacer()
                HStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        Text(items.count, format: .number)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .contentTransition(.numericText(value: Double(items.count)))
                        Text(" \(items.count == 1 ? "item" : "items") added")
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 75)
            .padding()
            .background(.thickMaterial,
                        in: RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .bottomTrailing) {
                ItemTypeDistributionChart(items: items)
                    .frame(width: 100, height: 100)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .opacity(0.5)
                    .chartLegend(.hidden)
                    .offset(x: -30, y: 20)
                    .animation(.default, value: items)
            }
            .clipped()
            
        }
        .tint(.primary)
    }
}

struct ItemAnalyticsDetailsView: View {
    var items: [Item]
    var sessions: [Session]
    var strains: [Strain]
    @Binding var filter: DateFilter
    
    @State private var selectedItem: Item?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Menu {
                    Picker("Item", selection: $selectedItem.animation()) {
                        Text("All Items").tag(nil as Item?)
                        ForEach(items) { item in
                            Text(item.name).tag(item as Item?)
                        }
                    }
                } label: {
                    Group {
                        if let selectedItem {
                            HStack {
                                Text(selectedItem.name)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        } else {
                            HStack {
                                Text("All Items")
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                }
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .tint(.primary)
                
                filter.dateLabel
                    .font(.caption)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            VStack(alignment: .leading) {
                if selectedItem != nil {
                    SelectedItemAnalyticsView(item: $selectedItem, filter: $filter)
                } else {
                    AllItemsAnalyticsView(items: items, sessions: sessions, strains: strains, filter: $filter)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
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
        ScrollView {
            VStack {
                ItemAnalyticsDetailsView(items: [SampleData.shared.item], sessions: filteredSessions, strains: [SampleData.shared.strain], filter: $filter)
            }
        }
    }
    .modelContainer(SampleData.shared.container)
}

#Preview {
    @Previewable @State var filter: DateFilter = .week
    
    var filteredSessions: [Session] {
        let (startDate, endDate) = filter.dateRange()
        return SampleData.shared.randomDatesSessions.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    NavigationStack {
        VStack {
            ItemAnalyticsView(items: [SampleData.shared.item], sessions: filteredSessions, strains: [SampleData.shared.strain], filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}
