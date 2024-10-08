//
//  MoodAnalyticsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/1/24.
//

import SwiftUI
import Charts

struct MoodAnalyticsView: View {
    var sessions: [Session]
    @Binding var filter: DateFilter
    
    var body: some View {
        NavigationLink {
            MoodsAnalyticsDetailsView(sessions: sessions, filter: $filter)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "theatermasks.fill")
                        .foregroundStyle(.purple.opacity(0.5))
                    Text("Moods")
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
                        let moodsCount = sessionsWithMoods().count
                        Text(moodsCount, format: .number)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .contentTransition(.numericText(value: Double(sessions.count)))
                        Text(" \(moodsCount == 1 ? "mood" : "moods") logged")
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
                MoodPieChartView(sessions: sessions)
                    .frame(width: 100, height: 100)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .opacity(0.5)
                    .chartLegend(.hidden)
                    .offset(x: -30, y: 20)
            }
            .clipped()
            
        }
        .tint(.primary)
    }
    
    private func sessionsWithMoods() -> [Session] {
        sessions.filter { $0.mood != nil }
    }
}

struct MoodsAnalyticsDetailsView: View {
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
                    Text("Moods")
                        .font(.title3)
                        .fontWeight(.semibold)
                    filter.dateLabel
                        .font(.caption)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 20) {
                    GroupBox("Average Weekday Mood") {
                        moodTrendChart
                            .frame(height: 200)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                    GroupBox("Moods Logged") {
                        MoodPieChartView(sessions: sessions)
                            .frame(height: 300)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                    GroupBox("Top Emotions") {
                        topEmotionsChart
                            .frame(height: 200)
                    }
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                }
            }
            .animation(.default, value: sessions)
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var moodTrendChart: some View {
        Chart(averageWeekdayMoods(), id: \.weekday) { weekdayMood in
            BarMark(
                x: .value("Weekday", weekdayMood.weekday),
                y: .value("Average Mood", weekdayMood.averageMood)
            )
            .foregroundStyle(.accent)
            RuleMark(y: .value("Neutral", 0))
                .foregroundStyle(.gray.opacity(0.5))
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) { value in
                if let doubleValue = value.as(Double.self),
                   let moodType = MoodType(rawValue: doubleValue) {
                    AxisValueLabel {
                        Text(moodType.label)
                            .font(.caption)
                    }
                }
            }
        }
        .chartYScale(domain: -1...1)
    }
    
    private var moodDistributionChart: some View {
        Chart(MoodType.allCases, id: \.self) { moodType in
            BarMark(
                x: .value("Mood", moodType.label),
                y: .value("Count", moodCount(for: moodType))
            )
            .foregroundStyle(moodType.color)
        }
    }
    
    private var topEmotionsChart: some View {
        Chart(topEmotions(), id: \.name) { emotion in
            BarMark(
                x: .value("Emotion", emotion.name),
                y: .value("Count", emotion.count)
            )
            .cornerRadius(8.0)
            .foregroundStyle(by: .value("Emotion", emotion.name))
        }
        .chartLegend(.hidden)
    }
    
    private func averageWeekdayMoods() -> [(weekday: String, averageMood: Double)] {
        let calendar = Calendar.autoupdatingCurrent
        let groupedSessions = Dictionary(grouping: sessionsWithMoods()) { session in
            calendar.component(.weekday, from: session.date)
        }
        
        return (1...7).map { weekday in
            let sessions = groupedSessions[weekday] ?? []
            let totalMood = sessions.compactMap { $0.mood?.type?.rawValue }.reduce(0, +)
            let averageMood = sessions.isEmpty ? 0 : totalMood / Double(sessions.count)
            return (weekday: calendar.shortWeekdaySymbols[weekday-1], averageMood: averageMood)
        }
    }
    
    private func topEmotions() -> [(name: String, count: Int)] {
        let emotions = sessions.flatMap { $0.mood?.emotions ?? [] }
        let counts = emotions.reduce(into: [:]) { counts, emotion in
            counts["\(emotion.emoji ?? "") \(emotion.name)", default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(4).map { ($0.key, $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    private func sessionsWithMoods() -> [Session] {
        sessions.filter { $0.mood != nil }
    }
    
    private func moodCount(for moodType: MoodType) -> Int {
        sessions.filter { $0.mood?.type == moodType }.count
    }
}



#Preview {
    @Previewable @State var filter: DateFilter = .week
    var filteredSessions: [Session] {
        let (startDate, endDate) = filter.dateRange()
        return SampleData.shared.randomDatesSessions.filter {
            $0.date >= startDate && $0.date <= endDate
        }
    }
    
    NavigationStack {
        VStack {
            MoodsAnalyticsDetailsView(sessions: filteredSessions, filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}

#Preview {
    @Previewable @State var filter: DateFilter = .week
    NavigationStack {
        VStack {
            MoodAnalyticsView(sessions: SampleData.shared.randomDatesSessions, filter: $filter)
        }
    }
    .modelContainer(SampleData.shared.container)
}
