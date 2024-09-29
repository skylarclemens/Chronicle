//
//  SessionDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/22/24.
//

import SwiftUI
import SwiftData

struct SessionDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var session: Session?
    @State private var isEditing = false
    @State private var isDeleting = false

    var fromItem: Bool = false
    
    var body: some View {
        if let session {
            ScrollView {
                VStack(alignment: .leading) {
                    if let imagesData = session.imagesData {
                        HorizontalImagesView(imagesData: imagesData, rotateImages: true, showAllImages: false, allowImageViewer: true)
                            .frame(height: 180)
                    }
                    HStack {
                        Text(session.title)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .padding(.vertical, 1)
                        if session.favorite {
                            Image(systemName: "bookmark.fill")
                                .font(.caption)
                                .foregroundStyle(.accent)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if let item = session.item {
                        HStack {
                            VStack {
                                if !fromItem {
                                    NavigationLink {
                                        ItemDetailsView(item: item)
                                    } label: {
                                        Label(item.name, systemImage: "link")
                                            .font(.footnote)
                                    }
                                } else {
                                    Label(item.name, systemImage: "link")
                                        .font(.footnote)
                                        .foregroundStyle(.accent)
                                }
                            }
                            .infoPillStyle(.accent)
                            if let strain = item.strain {
                                Text(strain.type.rawValue.localizedCapitalized)
                                    .font(.footnote)
                                    .infoPillStyle()
                            }
                        }
                    }
                    
                    if session.amountConsumed != nil || !session.accessories.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Details")
                                .font(.title2)
                                .fontWeight(.semibold)
                            if let amountConsumed = session.amountConsumed {
                                DetailSection(header: "Amount") {} headerRight: {
                                    HStack(spacing: 0) {
                                        Text(amountConsumed, format: .number)
                                        Text(" \(session.item?.unit ?? "")")
                                    }
                                }
                                
                            }
                            if !session.accessories.isEmpty {
                                DetailSection(header: "Accessories", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(session.accessories) { accessory in
                                                NavigationLink {
                                                    AccessoryDetailsView(accessory: accessory)
                                                } label: {
                                                    Label(accessory.name, systemImage: accessory.type.symbol())
                                                }
                                                .foregroundStyle(.primary)
                                                .pillStyle()
                                            }
                                        }
                                    }
                                    .contentMargins(.horizontal, 16)
                                    .scrollIndicators(.hidden)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    
                    if let notes = session.notes, !notes.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .font(.title2)
                                .fontWeight(.semibold)
                            DetailSection {
                                Text(notes)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                        }
                        .padding(.top)
                    }
                    if let mood = session.mood {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Mood")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    Text(mood.type.label)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(mood.type.color.opacity(0.33))
                                        )
                                    Spacer()
                            }
                            if !mood.emotions.isEmpty {
                                DetailSection(header: "Feelings", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(mood.emotions, id: \.self) { emotion in
                                                HStack {
                                                    Text(emotion.emoji ?? "")
                                                        .font(.system(size: 12))
                                                    Text(emotion.name)
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                }
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(.ultraThinMaterial)
                                                )
                                            }
                                        }
                                    }
                                    .contentMargins(.horizontal, 16)
                                    .scrollIndicators(.hidden)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    if let audioData = session.audioData {
                        VStack(alignment: .leading) {
                            Text("Audio")
                                .font(.title2)
                                .fontWeight(.semibold)
                            DetailSection {
                                AudioPlayerView(audioData: audioData)
                            }
                        }
                        .padding(.top)
                    }
                    if !session.tags.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags")
                                .font(.title2)
                                .fontWeight(.semibold)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(session.tags) { tag in
                                        Text(tag.name)
                                            .tagStyle()
                                    }
                                }
                            }
                            .contentMargins(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.secondarySystemGroupedBackground),
                                        in: RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.top)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(session.date, style: .date)
                            .font(.system(.headline, design: .rounded))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Options", systemImage: "ellipsis") {
                        Section {
                            Button {
                                isEditing = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                isDeleting = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        Button {
                            session.favorite.toggle()
                            do {
                                try modelContext.save()
                            } catch {
                                print("Failed to save model context.")
                            }
                        } label: {
                            Label(session.favorite ? "Remove bookmark" : "Bookmark", systemImage: session.favorite ? "bookmark.slash" : "bookmark")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Are you sure you want to delete \(session.title)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    do {
                        try delete(session)
                    } catch {
                        print("Could not save session deletion.")
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                SessionEditorView(session: session)
            }
            .background(Color(.systemGroupedBackground))
        } else {
            ContentUnavailableView("Session unavailable", systemImage: "tray")
        }
    }
    
    private func delete(_ session: Session) throws {
        withAnimation {
            modelContext.delete(session)
            self.session = nil
        }
        try modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        SessionDetailsView(session: SampleData.shared.session)
            .environment(ImageViewManager())
    }
    .modelContainer(SampleData.shared.container)
}
