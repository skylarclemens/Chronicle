//
//  SessionRowView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct SessionRowView: View {
    @Environment(\.modelContext) var modelContext
    var session: Session?
    
    var effectsPrefix: [Effect] {
        if showEffects,
           let session {
            return Array(session.effects?.prefix(2) ?? [])
        }
        return []
    }
    
    var leftoverEffects: Int? {
        if showEffects,
           let session,
           let effects = session.effects {
            let count = effects.count - effectsPrefix.count
            if count > 0 {
                return count
            }
            return nil
        }
        return nil
    }
    
    var showEffects: Bool = false
    var showNotes: Bool = true
    var showMood: Bool = true
    
    var body: some View {
        if let session {
            VStack {
                ImageGridView(imagesData: session.imagesData, height: 100, cornerRadius: 8, allowImageViewer: false)
                HStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(session.title)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                    .bold()
                                if session.favorite {
                                    Image(systemName: "bookmark.fill")
                                        .foregroundStyle(.accent)
                                }
                                Spacer()
                                HStack(spacing: 4) {
                                    if let notes = session.notes, !notes.isEmpty {
                                        Image(systemName: "note.text")
                                    }
                                    if session.audioData != nil {
                                        Image(systemName: "waveform")
                                    }
                                    if let mood = session.mood {
                                        Image(systemName: "face.smiling.inverse")
                                    }
                                    if let effects = session.effects, !effects.isEmpty {
                                        Image(systemName: "theatermasks")
                                    }
                                    if let activities = session.activities, !activities.isEmpty {
                                        Image(systemName: "figure.run")
                                    }
                                    if let wellnessEntries = session.wellnessEntries, !wellnessEntries.isEmpty {
                                        Image(systemName: "heart")
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                            HStack {
                                if let item = session.item {
                                    Text(item.name)
                                        .infoPillStyle(.accent, horizontalSpacing: 8, verticalSpacing: 3)
                                }
                                if let amountConsumed = session.transaction,
                                   let displayValue = amountConsumed.displayValue,
                                   displayValue > 0 {
                                    Group {
                                        Text(displayValue.round(toNearest: 0.01), format: .number) +
                                        Text(" \(amountConsumed.unit)")
                                    }
                                    .infoPillStyle(horizontalSpacing: 6, verticalSpacing: 3)
                                }
                                if showMood, let mood = session.mood {
                                    Text(mood.type?.label ?? "")
                                        .infoPillStyle(mood.type?.color, horizontalSpacing: 6, verticalSpacing: 3)
                                }
                            }
                            .font(.caption)
                        }
                        .padding(.top, 4)
                        if showNotes,
                           let notes = session.notes,
                           !notes.isEmpty {
                            Text(notes)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 4)
                        }
                        if showEffects,
                           !effectsPrefix.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(effectsPrefix) { effect in
                                    Text(effect.name)
                                        .infoPillStyle(horizontalSpacing: 6, verticalSpacing: 3)
                                }
                                if let leftoverEffects {
                                    Group {
                                        Text("+") +
                                        Text(leftoverEffects, format: .number)
                                    }
                                    .infoPillStyle(horizontalSpacing: 6, verticalSpacing: 3)
                                }
                            }
                            .font(.caption)
                        }
                        Divider()
                        HStack {
                            Text(session.date, style: .date)
                            Spacer()
                            Text(session.date, style: .time)  
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 2)
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding(8)
            .background(.thickMaterial)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.bar, lineWidth: 1)
                    .allowsHitTesting(false)
            )
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            SessionRowView(session: SampleData.shared.session)
            SessionRowView(session: SampleData.shared.randomDatesSessions[0])
            SessionRowView(session: SampleData.shared.randomDatesSessions[1])
        }
    }
    .padding(.horizontal)
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
