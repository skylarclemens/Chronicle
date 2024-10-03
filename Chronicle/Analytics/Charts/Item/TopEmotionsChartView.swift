//
//  TopEmotionsChartView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI
import Charts

struct TopEmotionsChartView: View {
    var topEmotions: [(emotion: Emotion, count: Int)]
    var showAnnotation: Bool = false
    
    var body: some View {
        Chart(topEmotions, id: \.emotion) { emotionCount in
            BarMark(
                x: .value("Count", emotionCount.count),
                y: .value("Emotion", emotionCount.emotion.name)
            )
            .clipShape(Capsule())
            .foregroundStyle(emotionCount.emotion == topEmotions.first?.emotion ? .blue : .secondary.opacity(0.5))
            .annotation(position: .trailing) {
                if showAnnotation {
                    Text(emotionCount.count, format: .number)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let nameValue = value.as(String.self) {
                        Text(nameValue)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}

struct TopEmotionsChartExpandedView: View {
    var item: Item
    var topEmotions: [(emotion: Emotion, count: Int)]
    
    var topTopEmotions: [String] {
        guard !topEmotions.isEmpty else { return [] }
        let highestCount = topEmotions.first!.count
        let topEmotions = topEmotions.filter { $0.count == highestCount }
        return topEmotions.map { $0.emotion.name }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Top Emotion\(topTopEmotions.count == 1 ? "" : "s")")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.secondary)
//                            Text("All time")
//                                .font(.caption)
//                                .fontWeight(.medium)
//                                .fontDesign(.rounded)
//                                .foregroundStyle(.tertiary)
                        }
                        if !topTopEmotions.isEmpty {
                            Text(topTopEmotions.joined(separator: ", "))
                                .font(.title2.weight(.medium))
                                .fontDesign(.rounded)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Chart(topEmotions, id: \.emotion) { emotionCount in
                        BarMark(
                            x: .value("Count", emotionCount.count),
                            y: .value("Emotion", emotionCount.emotion)
                        )
                        .clipShape(Capsule())
                        .foregroundStyle(by: .value("Emotion", emotionCount.emotion.name))
                        .annotation(position: .trailing) {
                            Text(emotionCount.count, format: .number)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .chartLegend(.hidden)
                    .chartXAxis(.hidden)
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let nameValue = value.as(String.self) {
                                    Text(nameValue)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                    Spacer()
                    NavigationLink {
                        ItemEmotionsView(item: item)
                    } label: {
                        HStack {
                            Text("View All Emotions")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.subheadline.bold())
                                .foregroundStyle(.tertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                    .buttonStyle(.plain)
                    .controlSize(.large)
                    .padding(.bottom)
                }
                .frame(height: proxy.size.height)
            }
            .frame(height: proxy.size.height)
            .contentMargins(.horizontal, 16)
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    var topEmotions: [(emotion: Emotion, count: Int)] {
        let emotions = SampleData.shared.randomDatesSessions.flatMap { $0.mood?.emotions ?? [] }
        let counts = emotions.reduce(into: [:]) { counts, emotion in
            counts[emotion, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(5).map { ($0.key, $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    NavigationStack {
        TopEmotionsChartExpandedView(item: SampleData.shared.item, topEmotions: topEmotions)
    }
    .modelContainer(SampleData.shared.container)
}

#Preview {
    var topEmotions: [(emotion: Emotion, count: Int)] {
        let emotions = SampleData.shared.randomDatesSessions.flatMap { $0.mood?.emotions ?? [] }
        let counts = emotions.reduce(into: [:]) { counts, emotion in
            counts[emotion, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(5).map { ($0.key, $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    TopEmotionsChartView(topEmotions: topEmotions)
        .modelContainer(SampleData.shared.container)
}
