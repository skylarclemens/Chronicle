//
//  CompactSessionCardView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/19/24.
//

import SwiftUI
import SwiftData

struct CompactSessionCardView: View {
    @Environment(\.modelContext) var modelContext
    var session: Session?
    var imageHeight: CGFloat = 65
    var imageWidth: CGFloat = 65
    
    var body: some View {
        if let session {
            HStack {
                if let imageData = session.imagesData?.first {
                    VStack {
                        Image(uiImage: UIImage(data: imageData)!)
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: imageWidth, height: imageHeight)
                    .cornerRadius(8)
                    .clipped()
                }
                VStack(alignment: .leading, spacing: 0) {
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
                    .padding(.top, 4)
                    Spacer()
                    Divider()
                        .padding(.bottom, 4)
                    HStack(spacing: 4) {
                        Text(session.date, style: .date)
                        Text("•")
                        Text(session.date, style: .time)
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
                }
                .padding(.horizontal, 4)
            }
            .padding(8)
            .frame(maxHeight: 80)
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
    NavigationStack {
        VStack {
            CompactSessionCardView(session: SampleData.shared.session)
        }
    }
    .background(
        BackgroundView()
    )
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
