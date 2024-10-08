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
    
    var topEmotions: [Emotion] {
        guard !allTopEmotions.isEmpty else { return [] }
        let highestCount = allTopEmotions.first!.count
        let topEmotions = allTopEmotions.filter { $0.count == highestCount }
        return topEmotions.map { $0.emotion }
    }
    
    var topEmotionsStrings: [String] {
        topEmotions.map { $0.name }
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
                        ForEach(moodTypes.sorted { $0.value > $1.value }, id: \.key) { moodType, count in
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
                                    .background(.primary.opacity(0.075),
                                                in: RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(moodType.color.opacity(0.33))
                                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 2))
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.primary.opacity(0.05)))
                            
                        }
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                NavigationLink {
                    TopEmotionsChartExpandedView(item: item, allTopEmotions: allTopEmotions, topEmotions: topEmotions)
                } label: {
                    DetailSection(header: "Top Emotion\(topEmotionsStrings.count == 1 ? "" : "s")") {
                        if !topEmotionsStrings.isEmpty {
                            Text(topEmotionsStrings.joined(separator: ", "))
                                .font(.title2.weight(.medium))
                                .fontDesign(.rounded)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                        }
                        TopEmotionsChartView(allTopEmotions: allTopEmotions, topEmotions: topEmotions)
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
            ItemMoodInsightsView(item: SampleData.shared.item, moods: SampleData.shared.item.moods, sessions: SampleData.shared.item.sessions!)
        }
    }
    .modelContainer(SampleData.shared.container)
}
