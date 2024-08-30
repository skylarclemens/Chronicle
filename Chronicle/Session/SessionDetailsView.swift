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
                    if let item = session.item {
                        HStack {
                            VStack {
                                if !fromItem {
                                    NavigationLink {
                                        ItemDetailsView(item: item, fromSession: true)
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
                    if let notes = session.notes, !notes.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .font(.headline)
                            DetailSection {
                                Text(notes)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                        }
                        .padding(.top)
                    }
                    if !session.effects.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Effects")
                                .font(.headline)
                            if !session.sortedMoods.isEmpty {
                                DetailSection(header: "Moods", headerRight: "Intensity") {
                                    ForEach(session.sortedMoods) { effect in
                                        if let itemTrait = effect.itemTrait {
                                            HStack {
                                                Text(itemTrait.traitEmoji)
                                                    .font(.system(size: 14))
                                                Text(itemTrait.traitName)
                                                    .font(.footnote)
                                                    .fontWeight(.medium)
                                                    .frame(width: 80, alignment: .leading)
                                                Spacer()
                                                ProgressView(value: Double(effect.intensity ?? 0)/10)
                                                Text(effect.intensity ?? 0, format: .number)
                                                    .font(.footnote)
                                                    .bold()
                                            }
                                        }
                                    }
                                }
                            }
                            if !session.sortedWellness.isEmpty {
                                DetailSection(header: "Wellness", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(session.sortedWellness) { effect in
                                                if let itemTrait = effect.itemTrait {
                                                    HStack {
                                                        Text(itemTrait.traitEmoji)
                                                            .font(.system(size: 12))
                                                        Text(itemTrait.traitName)
                                                            .font(.footnote)
                                                            .fontWeight(.medium)
                                                    }
                                                    .padding(.vertical, 6)
                                                    .padding(.horizontal, 8)
                                                    .background(.secondary,
                                                                in: RoundedRectangle(cornerRadius: 12))
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    if !session.flavors.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Flavors")
                                .font(.headline)
                            DetailSection(isScrollView: true) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(session.sortedFlavors) { flavor in
                                            if let itemTrait = flavor.itemTrait {
                                                HStack {
                                                    Text(itemTrait.traitEmoji)
                                                        .font(.system(size: 12))
                                                    Text(itemTrait.traitName)
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                }
                                                .padding(8)
                                                .background(itemTrait.traitColor.color.opacity(0.2),
                                                            in: RoundedRectangle(cornerRadius: 12))
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
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
        updateItemTraits()
        withAnimation {
            modelContext.delete(session)
            self.session = nil
        }
        try modelContext.save()
        dismiss()
    }
    
    private func updateItemTraits() {
        guard let session, let item = session.item else { return }
        
        for trait in session.traits {
            if let itemTrait = trait.itemTrait {
                itemTrait.sessionTraits.removeAll { $0.id == trait.id }
                if itemTrait.sessionTraits.isEmpty {
                    item.traits.removeAll { $0.id == itemTrait.id }
                    modelContext.delete(itemTrait)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SessionDetailsView(session: SampleData.shared.session)
            .environment(ImageViewManager())
    }
    .modelContainer(SampleData.shared.container)
}
