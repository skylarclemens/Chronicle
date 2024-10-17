//
//  SessionDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/22/24.
//

import SwiftUI
import SwiftData
import _MapKit_SwiftUI

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
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading) {
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
                                                Label {
                                                    Text(item.name)
                                                        .foregroundStyle(.primary)
                                                } icon: {
                                                    Image(systemName: "link")
                                                        .foregroundStyle(.accent)
                                                }
                                                .font(.footnote)
                                            }
                                            .buttonStyle(.plain)
                                        } else {
                                            Label {
                                                Text(item.name)
                                                    .foregroundStyle(.primary)
                                            } icon: {
                                                Image(systemName: "link")
                                                    .foregroundStyle(.accent)
                                            }
                                            .font(.footnote)
                                        }
                                    }
                                    .infoPillStyle(.accent)
                                    if let strain = item.strain,
                                       let strainType = strain.type {
                                        Text(strainType.rawValue.localizedCapitalized)
                                            .font(.footnote)
                                            .infoPillStyle()
                                    }
                                }
                            }
                        }
                        if !(session.accessories?.isEmpty ?? true) || session.transaction != nil {
                            VStack(alignment: .leading) {
                                Text("Details")
                                    .headerTitle()
                                if let amountConsumed = session.transaction {
                                    DetailSection(header: "Amount") {} headerRight: {
                                        HStack(spacing: 0) {
                                            Text(amountConsumed.displayValue ?? 0, format: .number) +
                                            Text(" \(amountConsumed.unit)")
                                        }
                                    }
                                }
                                if let accessories = session.accessories,
                                   !accessories.isEmpty {
                                    DetailSection(header: "Accessories", isScrollView: true) {
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(accessories) { accessory in
                                                    NavigationLink {
                                                        AccessoryDetailsView(accessory: accessory)
                                                    } label: {
                                                        Label(accessory.name, systemImage: accessory.type?.symbol() ?? "")
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
                        }
                        
                        if let notes = session.notes, !notes.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Notes")
                                    .headerTitle()
                                DetailSection {
                                    Text(notes)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                        }
                        if let mood = session.mood {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Mood")
                                        .headerTitle()
                                    if let moodType = mood.type {
                                        Text(moodType.label)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(moodType.color.opacity(0.33))
                                            )
                                    }
                                    Spacer()
                                }
                                if let emotions = mood.emotions,
                                   !emotions.isEmpty {
                                    DetailSection(header: "Feelings", isScrollView: true) {
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(emotions, id: \.self) { emotion in
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
                        }
                        if let wellnessEntries = session.wellnessEntries,
                           !wellnessEntries.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Wellness")
                                    .headerTitle()
                                DetailSection(isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(wellnessEntries) { entry in
                                                if let wellness = entry.wellness {
                                                    HStack {
                                                        Text(wellness.name)
                                                            .font(.subheadline)
                                                            .fontWeight(.medium)
                                                        if let intensity = entry.intensity {
                                                            Text(intensity, format: .number)
                                                                .font(.footnote)
                                                                .padding(.horizontal, 6)
                                                                .padding(.vertical, 2)
                                                                .background(Color(.secondarySystemFill),
                                                                            in: RoundedRectangle(cornerRadius: 6))
                                                        }
                                                    }
                                                    .pillStyle()
                                                }
                                            }
                                        }
                                    }
                                    .contentMargins(.horizontal, 16)
                                    .scrollIndicators(.hidden)
                                }
                            }
                        }
                        if let audioData = session.audioData {
                            VStack(alignment: .leading) {
                                Text("Audio")
                                    .headerTitle()
                                DetailSection {
                                    AudioPlayerView(audioData: audioData)
                                }
                            }
                        }
                        if let location = session.locationInfo,
                           let mapItem = location.getMapData() {
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .headerTitle()
                                Map(interactionModes: []) {
                                    Annotation(location.name ?? "", coordinate: mapItem.placemark.coordinate) {
                                        Text(location.name ?? "")
                                    }
                                }
                                .frame(height: 125)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                        }
                        if let tags = session.tags,
                           !tags.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Tags")
                                    .headerTitle()
                                DetailSection(isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(tags) { tag in
                                                Text(tag.name)
                                                    .tagStyle()
                                            }
                                        }
                                    }
                                    .contentMargins(.horizontal, 16)
                                }
                            }
                        }
                        Spacer()
                    }
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
