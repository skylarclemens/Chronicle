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
                    ImageGridView(imagesData: session.imagesData, cornerRadius: 4)
                        .padding(.vertical)
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
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                            .frame(maxHeight: 24)
                            .background(.accent.opacity(0.2),
                                        in: RoundedRectangle(cornerRadius: 24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                            if let strain = item.strain {
                                Text(strain.type.rawValue.localizedCapitalized)
                                    .font(.footnote)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.ultraThickMaterial,
                                                in: RoundedRectangle(cornerRadius: 24))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.tertiary, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    if let amountConsumed = session.amountConsumed {
                        DetailSection(header: "Amount") {} headerRight: {
                            HStack(spacing: 0) {
                                Text(amountConsumed, format: .number)
                                Text(" \(session.item?.unit ?? "")")
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
