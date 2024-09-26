//
//  UsagePatternsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/25/24.
//

import SwiftUI
import Charts
import SwiftData

struct UsagePatternsView: View {
    @Query private var sessions: [Session]
    @Binding private var filter: DateFilter
    
    var body: some View {
        NavigationLink {
            ScrollView {
                VStack(alignment: .leading) {
                    Picker("Date Range", selection: $filter.animation()) {
                        ForEach(DateFilter.allCases, id: \.self) { filterSelection in
                            Text(filterSelection.rawValue.localizedCapitalized).tag(filterSelection)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Sessions Logged")
                                .font(.title3)
                                .fontWeight(.semibold)
                            dateLabel
                                .font(.caption)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundStyle(.secondary)
                        }
                        chart
                            .frame(height: 250)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            if !sessions.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: "rectangle.stack.fill")
                                            .foregroundStyle(.primary.opacity(0.5))
                                        Text(sessions.count, format: .number)
                                            .contentTransition(.numericText(value: Double(sessions.count)))
                                    }
                                    Text("TOTAL SESSIONS")
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
                        HStack {
                            if let mostUsedItem = mostUsedItem() {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mostUsedItem.name)
                                        .contentTransition(.interpolate)
                                    Text("MOST USED ITEM")
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
                            if let mostUsedStrain = mostUsedStrain() {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mostUsedStrain)
                                        .contentTransition(.interpolate)
                                    Text("MOST USED STRAIN")
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
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "rectangle.stack.fill")
                        .foregroundStyle(.primary.opacity(0.5))
                    Text("Sessions Logged")
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                        .foregroundStyle(.tertiary)
                }
                HStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        Text(sessions.count, format: .number)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .contentTransition(.numericText(value: Double(sessions.count)))
                        Text(" sessions")
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom)
                    Spacer()
                    chart
                        .frame(width: 80, height: 60)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .opacity(0.5)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .background(Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
        }
        .tint(.primary)
    }
    
    @ViewBuilder
    var chart: some View {
        switch filter {
        case .week:
            weekChart
        case .month:
            monthChart
        case .year:
            yearChart
        }
    }
    
    var weekChart: some View {
        Chart(groupSessionsByDay()) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Sessions", $0.count)
            )
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .chartXScale(domain: filter.dateRange().0...filter.dateRange().1)
    }
    
    var monthChart: some View {
        Chart(groupSessionsByDay()) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Sessions", $0.count)
            )
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day())
            }
        }
    }
    
    var yearChart: some View {
        Chart(groupSessionsByMonth()) {
            BarMark(
                x: .value("Date", $0.date, unit: .month),
                y: .value("Sessions", $0.count)
            )
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month(.abbreviated))
            }
        }
        .chartXScale(domain: filter.dateRange().0...Date())
    }
    
    private func groupSessionsByDay() -> [SessionCount] {
        let groupedSessions = Dictionary(grouping: sessions) { session in
            Calendar.autoupdatingCurrent.startOfDay(for: session.date)
        }
        return groupedSessions.map {
            SessionCount(date: $0.key, count: $0.value.count)
        }.sorted { $0.date < $1.date }
    }
    
    private func groupSessionsByMonth() -> [SessionCount] {
        let calendar = Calendar.autoupdatingCurrent
        let groupedSessions = Dictionary(grouping: sessions) { session in
            calendar.date(from: calendar.dateComponents([.year, .month], from: session.date))!
        }
        return groupedSessions.map {
            SessionCount(date: $0.key, count: $0.value.count)
        }.sorted { $0.date < $1.date }
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
    
    @ViewBuilder
    var dateLabel: some View {
        switch filter {
        case .week:
            HStack(spacing: 0){
                Text(filter.dateRange().0.formatted(date: .abbreviated, time: .omitted))
                Text("-")
                Text(filter.dateRange().1.formatted(date: .abbreviated, time: .omitted))
            }
        case .month:
            Text(filter.dateRange().0, format: .dateTime.month(.wide).year())
        case .year:
            Text(filter.dateRange().0, format: .dateTime.year())
        }
    }
    
    init(filter: Binding<DateFilter>) {
        self._filter = filter
        let (startDate, endDate) = filter.wrappedValue.dateRange()
        _sessions = Query(filter: Session.dateRangePredicate(startDate: startDate, endDate: endDate), sort: \Session.createdAt, order: .reverse)
    }
    
    private struct SessionCount: Identifiable {
        let id: UUID = UUID()
        let date: Date
        let count: Int
    }
}

#Preview {
    @Previewable @State var filter: DateFilter = .week
    NavigationStack {
        VStack {
            UsagePatternsView(filter: $filter)
        }
    }
    .modelContext(SampleData.shared.context)
}
