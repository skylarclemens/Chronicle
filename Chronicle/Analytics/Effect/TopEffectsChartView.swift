//
//  TopEffectsChartView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI
import Charts

struct TopEffectsChartView: View {
    var allTopEffects: [(effect: Effect, count: Int)]
    var topEffects: [Effect]
    var showAnnotation: Bool = false
    
    var body: some View {
        Chart(allTopEffects, id: \.effect) { effectCount in
            BarMark(
                x: .value("Count", effectCount.count),
                y: .value("Effect", effectCount.effect.name),
                height: .fixed(10)
            )
            .clipShape(Capsule())
            .foregroundStyle(topEffects.contains { $0.name == effectCount.effect.name } ? .blue : .secondary.opacity(0.5))
            .annotation(position: .trailing) {
                if showAnnotation {
                    Text(effectCount.count, format: .number)
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

struct TopEffectsChartExpandedView: View {
    var item: Item
    var allTopEffects: [(effect: Effect, count: Int)]
    var topEffects: [Effect]
    
    var topEffectsStrings: [String] {
        topEffects.map { $0.name }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Top Effect\(topEffects.count == 1 ? "" : "s")")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.secondary)
                        }
                        if !topEffectsStrings.isEmpty {
                            Text(topEffectsStrings.joined(separator: ", "))
                                .font(.title2.weight(.medium))
                                .fontDesign(.rounded)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Chart(allTopEffects, id: \.effect) { effectCount in
                        let effectDisplayName = "\(effectCount.effect.emoji ?? "") \(effectCount.effect.name)"
                        BarMark(
                            x: .value("Count", effectCount.count),
                            y: .value("Effect", effectDisplayName),
                            height: .fixed(10)
                        )
                        .clipShape(Capsule())
                        .foregroundStyle(by: .value("Effect", effectDisplayName))
                        .annotation(position: .trailing) {
                            Text(effectCount.count, format: .number)
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
                                }
                            }
                        }
                    }
                    .frame(height: CGFloat(allTopEffects.count * 50))
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                    Spacer()
                    NavigationLink {
                        ItemEffectsView(item: item)
                    } label: {
                        HStack {
                            Text("View All Effects")
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
    var allTopEffects: [(effect: Effect, count: Int)] {
        let effects = SampleData.shared.randomDatesSessions.flatMap { $0.effects ?? [] }
        let counts = effects.reduce(into: [:]) { counts, effect in
            counts[effect, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(5).map { ($0.key, $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    var topEffects: [Effect] {
        guard !allTopEffects.isEmpty else { return [] }
        let highestCount = allTopEffects.first!.count
        let topEffects = allTopEffects.filter { $0.count == highestCount }
        return topEffects.map { $0.effect }
    }
    
    NavigationStack {
        TopEffectsChartExpandedView(item: SampleData.shared.item, allTopEffects: allTopEffects, topEffects: topEffects)
    }
    .modelContainer(SampleData.shared.container)
}

#Preview {
    var allTopEffects: [(effect: Effect, count: Int)] {
        let effects = SampleData.shared.randomDatesSessions.flatMap { $0.effects ?? [] }
        let counts = effects.reduce(into: [:]) { counts, effect in
            counts[effect, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(5).map { ($0.key, $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    var topEffects: [Effect] {
        guard !allTopEffects.isEmpty else { return [] }
        let highestCount = allTopEffects.first!.count
        let topEffects = allTopEffects.filter { $0.count == highestCount }
        return topEffects.map { $0.effect }
    }
    
    ScrollView {
        TopEffectsChartView(allTopEffects: allTopEffects, topEffects: topEffects)
            .frame(height: 75)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
    }
    .modelContainer(SampleData.shared.container)
}
