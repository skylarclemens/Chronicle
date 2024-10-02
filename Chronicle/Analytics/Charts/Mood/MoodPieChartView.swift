//
//  MoodPieChartView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI
import Charts

struct MoodPieChartView: View {
    var sessions: [Session]
    
    private var moodCounts: [MoodCount] {
        let counts: [MoodType: Int] = sessions.reduce(into: [:]) { counts, session in
            if let mood = session.mood {
                counts[mood.type, default: 0] += 1
            }
        }
        return Array(counts).sorted {
            $0.key.rawValue < $1.key.rawValue
        }.map {
            MoodCount(mood: $0.key, count: $0.value)
        }
    }
    
    @State private var selectedAngle: Double?
    var selectedMoodCount: MoodCount? {
        if let selectedAngle {
            return getSelectedMoodCount(value: selectedAngle)
        }
        return nil
    }
    
    var body: some View {
        Chart(moodCounts, id: \.mood.label) { moodCount in
            SectorMark(
                angle: .value("Count", moodCount.count),
                innerRadius: .ratio(0.55),
                angularInset: 3.0
            )
            .cornerRadius(8.0)
            .foregroundStyle(moodCount.mood.color)
            .opacity(selectedMoodCount == nil ? 1.0 : (selectedMoodCount?.mood.label == moodCount.mood.label ? 1.0 : 0.5))
        }
        .chartForegroundStyleScale(domain: MoodType.allCases.map { $0.label },
                                   range: MoodType.allCases.map { $0.color })
        .chartAngleSelection(value: $selectedAngle)
        .chartBackground { chartProxy in
            GeometryReader { proxy in
                let frame = proxy[chartProxy.plotFrame!]
                if let selectedMoodCount {
                    VStack {
                        Text(selectedMoodCount.mood.label)
                        Text(selectedMoodCount.count, format: .number)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartLegend(position: .top, alignment: .leading)
    }
        
    private func mostCommonMood() -> String? {
        moodCounts.max(by: { $0.count > $1.count })?.mood.label
    }
    
    private func getSelectedMoodCount(value: Double) -> MoodCount? {
        var accumulatedCount: Double = 0
        
        let mood = moodCounts.first { moodCount in
            accumulatedCount += Double(moodCount.count)
            return value <= accumulatedCount
        }
        
        return mood
    }
    
    struct MoodCount: Identifiable {
        let id = UUID()
        var mood: MoodType
        var count: Int
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
    
    VStack {
        Picker("Date Range", selection: $filter.animation()) {
            ForEach(DateFilter.allCases, id: \.self) { filterSelection in
                Text(filterSelection.rawValue.localizedCapitalized).tag(filterSelection)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        MoodPieChartView(sessions: SampleData.shared.randomDatesSessions)
            .modelContainer(SampleData.shared.container)
    }
}
