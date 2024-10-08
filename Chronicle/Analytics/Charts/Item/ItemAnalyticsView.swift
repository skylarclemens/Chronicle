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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker("Date Range", selection: $filter.animation()) {
                    ForEach(DateFilter.allCases, id: \.self) { filterSelection in
                        Text(filterSelection.rawValue.localizedCapitalized).tag(filterSelection)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                VStack(alignment: .leading) {
                    Text("Items")
                        .font(.title3)
                        .fontWeight(.semibold)
                    filter.dateLabel
                        .font(.caption)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 20) {
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
                    .animation(.default, value: sessions)
                    GroupBox("Item Type Distribution") {
                        ItemTypeDistributionChart(items: items)
                            .frame(height: 250)
                            .animation(.default, value: items)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                    GroupBox("Average Mood by Item") {
                        averageMoodByItemChart
                            .frame(height: 200)
                            .animation(.default, value: sessions)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                    GroupBox("Number of Sessions per Item") {
                        sessionCountsPerItem
                            .frame(height: 200)
                            .animation(.default, value: sessions)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                }
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var averageMoodByItemChart: some View {
        Chart(averageMoodByItem().prefix(5), id: \.item) { moodData in
            BarMark(
                x: .value("Item", moodData.item),
                y: .value("Average Mood", moodData.averageMood)
            )
            .foregroundStyle(.purple)
            .cornerRadius(4)
            RuleMark(y: .value("Neutral", 0))
                .foregroundStyle(.gray.opacity(0.5))
        }
        .chartYScale(domain: -1...1)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let doubleValue = value.as(Double.self),
                   let moodType = MoodType(rawValue: doubleValue) {
                    AxisValueLabel {
                        Text(moodType.label)
                            .font(.caption)
                    }
                }
            }
        }
    }
    
    private var sessionCountsPerItem: some View {
        Chart(sessionCountPerItem(), id: \.item) { sessionCounts in
            BarMark(
                x: .value("Item", sessionCounts.item),
                y: .value("Count", sessionCounts.count)
            )
            .foregroundStyle(.blue)
            .cornerRadius(4)
        }
    }
    
    private func mostUsedStrain() -> String? {
        let strainCounts = sessions.compactMap {
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
        let itemCounts = sessions.compactMap(\.item).reduce(into: [:]) { counts, item in
            counts[item, default: 0] += 1
        }
        guard !itemCounts.isEmpty else { return nil }
        
        let maxCount = itemCounts.values.max()!
        let mostUsedItems = itemCounts.filter { $0.value == maxCount }.keys
        
        return mostUsedItems.min(by: { $0.createdAt < $1.createdAt })
    }
    
    private func averageMoodByItem() -> [(item: String, averageMood: Double)] {
        let itemMoods = sessions.compactMap { session -> (String, Double)? in
            guard let itemName = session.item?.name,
                  let moodValue = session.mood?.type?.rawValue else {
                return nil
            }
            return (itemName, moodValue)
        }
        
        let groupedMoods = Dictionary(grouping: itemMoods, by: { $0.0 })
        
        return groupedMoods.map { (item, moods) in
            let averageMood = moods.map{ $0.1 }.reduce(0, +) / Double(moods.count)
            return (item: item, averageMood: averageMood)
        }.sorted { $0.item < $1.item }
    }
    
    private func sessionCountPerItem() -> [(item: String, count: Int)] {
        let itemCounts = sessions.compactMap(\.item).reduce(into: [:]) { counts, item in
            counts[item, default: 0] += 1
        }
        return itemCounts.map { (item, count) in
            (item: item.name, count: count)
        }.sorted { $0.item < $1.item }
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
            ItemAnalyticsDetailsView(items: [SampleData.shared.item], sessions: filteredSessions, strains: [SampleData.shared.strain], filter: $filter)
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
