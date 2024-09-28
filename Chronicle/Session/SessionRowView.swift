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
    
    var body: some View {
        if let session {
            VStack {
                ImageGridView(imagesData: session.imagesData, height: 100, cornerRadius: 8, allowImageViewer: false)
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(session.title)
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .bold()
                            if session.favorite {
                                Image(systemName: "bookmark.fill")
                                    .foregroundStyle(.accent)
                            }
                            Spacer()
                            if let notes = session.notes, !notes.isEmpty {
                                Image(systemName: "note.text")
                                    .foregroundStyle(.secondary)
                            }
                            if session.audioData != nil {
                                Image(systemName: "waveform")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.caption)
                        Divider()
                        HStack {
                            Text(session.date, style: .date)
                            Spacer()
                            Text(session.date, style: .time)  
                        }
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 4)
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
    List {
        SessionRowView(session: SampleData.shared.session)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
