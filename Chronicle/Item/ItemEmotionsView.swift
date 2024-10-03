//
//  ItemEmotionsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI

struct ItemEmotionsView: View {
    var item: Item
    
    var allEmotions: [(emotion: Emotion, count: Int)] {
        let emotions = item.sessions.flatMap { $0.mood?.emotions ?? [] }
        let counts = emotions.reduce(into: [:]) { counts, emotion in
            counts[emotion, default: 0] += 1
        }
        return counts.sorted {
            $0.value > $1.value
        }.map { ($0.key, $0.value) }
            .sorted {
                if $0.count == $1.count {
                    return $0.emotion.name < $1.emotion.name
                }
                return $0.count > $1.count
            }
    }
    
    var body: some View {
        List {
            ForEach(allEmotions, id: \.emotion) { emotion, count in
                HStack {
                    Text(emotion.emoji ?? "")
                    Text(emotion.name)
                    Spacer()
                    Text(count, format: .number)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("All Emotions")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ItemEmotionsView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
}
