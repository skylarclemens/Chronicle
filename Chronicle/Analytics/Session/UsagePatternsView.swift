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
    var sessions: [Session]
    @Binding var filter: DateFilter
    
    var body: some View {
        NavigationLink {
            SessionUsageAnalyticsView(sessions: sessions, filter: $filter)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "rectangle.stack.fill")
                        .foregroundStyle(.primary.opacity(0.5))
                    Text("Sessions")
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
                        Text(" \(sessions.count == 1 ? "session" : "sessions") logged")
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom)
                    Spacer()
                    SessionsUsageChartView(sessions: sessions, filter: $filter)
                        .frame(width: 80, height: 60)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .opacity(0.5)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .background(.thickMaterial,
                        in: RoundedRectangle(cornerRadius: 12))
        }
        .tint(.primary)
    }
}

struct SessionUsageAnalyticsView: View {
    var sessions: [Session]
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
                    VStack(alignment: .leading) {
                        Text("Sessions")
                            .font(.title3)
                            .fontWeight(.semibold)
                        filter.dateLabel
                            .font(.caption)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                    }
                    GroupBox("Sessions Logged") {
                        SessionsUsageChartView(sessions: sessions, filter: $filter)
                            .frame(height: 250)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                }
                .animation(.default, value: filter)
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
                        }
                    }
                    
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct SessionsUsageChartView: View {
    var sessions: [Session]
    @Binding var filter: DateFilter
    
    var body: some View {
        chart
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
            UsagePatternsView(sessions: SampleData.shared.randomDatesSessions, filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}
