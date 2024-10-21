//
//  ItemEffectsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI

struct ItemEffectsView: View {
    var item: Item
    
    var allEffects: [(effect: Effect, count: Int)] {
        let effects = item.sessions?.flatMap { $0.effects ?? [] }
        let counts = effects?.reduce(into: [:]) { counts, effect in
            counts[effect, default: 0] += 1
        }
        return counts?.sorted {
            $0.value > $1.value
        }.map { ($0.key, $0.value) }
            .sorted {
                if $0.count == $1.count {
                    return $0.effect.name < $1.effect.name
                }
                return $0.count > $1.count
            } ?? []
    }
    
    var body: some View {
        List {
            ForEach(allEffects, id: \.effect) { effect, count in
                HStack {
                    Text(effect.emoji ?? "")
                    Text(effect.name)
                    Spacer()
                    Text(count, format: .number)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("All Effects")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ItemEffectsView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
}
