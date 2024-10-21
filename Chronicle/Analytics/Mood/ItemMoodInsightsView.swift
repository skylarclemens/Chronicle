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

    var sessions: [Session] {
        item.sessions ?? []
    }
    
    var moods: [Mood] {
        return sessions.compactMap { $0.mood }
    }
    
    var moodTypes: [MoodType: Int] {
        var counts: [MoodType: Int] = [:]
        for session in sessions {
            if let moodType = session.mood?.type {
                counts[moodType, default: 0] += 1
            }
        }
        return counts
    }
    
    var showHeader: Bool = false
    
    var body: some View {
        if !moods.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                if showHeader {
                    Text("Moods")
                        .headerTitle()
                        .padding(.horizontal)
                }
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            ItemMoodInsightsView(item: SampleData.shared.item)
        }
    }
    .modelContainer(SampleData.shared.container)
}
