//
//  ItemMoodInsightsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI
import Charts

struct ItemMoodInsightsView: View {
    var item: Item
    var moods: [Mood]
    var sessions: [Session]
    
    var moodTypes: [MoodType: Int] {
        var counts: [MoodType: Int] = [:]
        for session in sessions {
            if let moodType = session.mood?.type {
                counts[moodType, default: 0] += 1
            }
        }
        return counts
    }
    
    var allTopEmotions: [(emotion: Emotion, count: Int)] {
        let emotions = sessions.flatMap { $0.mood?.emotions ?? [] }
        let counts = emotions.reduce(into: [:]) { counts, emotion in
            counts[emotion, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(5).map { ($0.key, $0.value) }
            .sorted {
                if $0.count == $1.count {
                    return $0.emotion.name < $1.emotion.name
                }
                return $0.count > $1.count
            }
    }
    
    var topEmotions: [String] {
        guard !allTopEmotions.isEmpty else { return [] }
        let highestCount = allTopEmotions.first!.count
        let topEmotions = allTopEmotions.filter { $0.count == highestCount }
        return topEmotions.map { $0.emotion.name }
    }
    
    var body: some View {
        if !moods.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Moods")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(MoodType.allCases, id: \.self) { moodType in
                            if let count = moodTypes[moodType] {
                                HStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(maxWidth: 3, maxHeight: 14)
                                        .foregroundStyle(moodType.color)
                                    Text(moodType.label)
                                    Text(count, format: .number)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.background.opacity(0.33),
                                                    in: RoundedRectangle(cornerRadius: 8))
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(moodType.color.opacity(0.33),
                                            in: RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .contentMargins(.horizontal, 16)
                NavigationLink {
                    TopEmotionsChartExpandedView(item: item, topEmotions: allTopEmotions)
                } label: {
                    DetailSection(header: "Top Emotion\(topEmotions.count == 1 ? "" : "s")") {
                        if !topEmotions.isEmpty {
                            Text(topEmotions.joined(separator: ", "))
                                .font(.title2.weight(.medium))
                                .fontDesign(.rounded)
                                .lineLimit(2)
                        }
                        TopEmotionsChartView(topEmotions: allTopEmotions)
                            .frame(height: 75)
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                    } headerRight: {
                        Image(systemName: "chevron.right")
                            .font(.subheadline.bold())
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal)
                }
                .tint(.primary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            ItemMoodInsightsView(item: SampleData.shared.item, moods: SampleData.shared.item.moods, sessions: SampleData.shared.item.sessions)
        }
    }
    .modelContainer(SampleData.shared.container)
}
