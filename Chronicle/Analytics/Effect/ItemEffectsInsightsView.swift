//
//  ItemEffectsInsightsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/21/24.
//

import SwiftUI

struct ItemEffectsInsightsView: View {
    var item: Item
    var sessions: [Session] {
        item.sessions ?? []
    }
    
    /// Gets top 5 effects for the item
    var allTopEffects: [(effect: Effect, count: Int)] {
        let effects = sessions.flatMap { $0.effects ?? [] }
        let counts = effects.reduce(into: [:]) { counts, effect in
            counts[effect, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.prefix(5).map { ($0.key, $0.value) }
            .sorted {
                if $0.count == $1.count {
                    return $0.effect.name < $1.effect.name
                }
                return $0.count > $1.count
            }
    }
    
    /// Gets the effects with highest count
    var topEffects: [Effect] {
        guard !allTopEffects.isEmpty else { return [] }
        let highestCount = allTopEffects.first!.count
        let topEffects = allTopEffects.filter { $0.count == highestCount }
        return topEffects.map { $0.effect }
    }
    
    var topEffectsStrings: [String] {
        topEffects.map { $0.name }
    }
    
    var body: some View {
        if !allTopEffects.isEmpty {
            NavigationLink {
                TopEffectsChartExpandedView(item: item, allTopEffects: allTopEffects, topEffects: topEffects)
            } label: {
                DetailSection(header: "Top Effect\(topEffectsStrings.count == 1 ? "" : "s")") {
                    if !topEffectsStrings.isEmpty {
                        Text(topEffectsStrings.joined(separator: ", "))
                            .font(.title2.weight(.medium))
                            .fontDesign(.rounded)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.primary)
                    }
                    TopEffectsChartView(allTopEffects: allTopEffects, topEffects: topEffects)
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

#Preview {
    NavigationStack {
        ItemEffectsInsightsView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
}
