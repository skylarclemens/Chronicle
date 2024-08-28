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
    
    var body: some View {
        if let session {
            VStack {
                ImageGridView(imagesData: session.imagesData, height: 150, cornerRadius: 6, allowImageViewer: false)
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text(session.title)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .bold()
                        if let notes = session.notes, !notes.isEmpty {
                            Image(systemName: "note.text")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Divider()
                    HStack {
                        Text(session.date, style: .date)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal, 4)
            }
            .padding(8)
            .background(.thickMaterial)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
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
