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
    var session: Session?
    @State private var isDeleting = false

    var fromItem: Bool = false
    
    var sortedMoodEffects: [SessionEffect] {
        let moods = session?.effects.filter { $0.effect.type == .mood }
        return moods?.sorted {
            $0.intensity > $1.intensity
        } ?? []
    }
    
    var sortedWellnessEffects: [SessionEffect] {
        let wellness = session?.effects.filter { $0.effect.type == .wellness }
        return wellness?.sorted {
            $0.effect.name > $1.effect.name
        } ?? []
    }
    
    var body: some View {
        if let session {
            ScrollView {
                VStack(alignment: .leading) {
                    ImageGridView(imagesData: session.imagesData, cornerRadius: 4)
                        .padding(.vertical)
                    Text(session.title)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.semibold)
                        .padding(.vertical, 1)
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
                            
                            if !sortedMoodEffects.isEmpty {
                                DetailSection(header: "Moods", headerRight: "Intensity") {
                                    ForEach(sortedMoodEffects) { effect in
                                        HStack {
                                            Text(effect.effect.emoji)
                                                .font(.system(size: 14))
                                            Text(effect.effect.name)
                                                .font(.footnote)
                                                .fontWeight(.medium)
                                                .frame(width: 80, alignment: .leading)
                                            Spacer()
                                            ProgressView(value: Double(effect.intensity)/10)
                                            Text(effect.intensity, format: .number)
                                                .font(.footnote)
                                                .bold()
                                        }
                                    }
                                }
                            }
                            if !sortedWellnessEffects.isEmpty {
                                DetailSection(header: "Wellness", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(sortedWellnessEffects) { effect in
                                                HStack {
                                                    Text(effect.effect.emoji)
                                                        .font(.system(size: 12))
                                                    Text(effect.effect.name)
                                                        .font(.footnote)
                                                        .fontWeight(.medium)
                                                }
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 8)
                                                .background(.secondary,
                                                            in: RoundedRectangle(cornerRadius: 12))
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
                                            HStack {
                                                Text(flavor.flavor.emoji)
                                                    .font(.system(size: 12))
                                                Text(flavor.flavor.name)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(8)
                                            .background(flavor.flavor.color.color.opacity(0.2),
                                                        in: RoundedRectangle(cornerRadius: 12))
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
                        Button(role: .destructive) {
                            isDeleting = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Are you sure you want to delete \(session.title)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    delete(session)
                }
            }
        } else {
            ContentUnavailableView("Session unavailable", systemImage: "tray")
        }
    }
    
    private func delete(_ session: Session) {
        //updateItemEffectsAndFlavors()
        withAnimation {
            modelContext.delete(session)
        }
        dismiss()
    }
    
    /*private func updateItemEffectsAndFlavors() {
        guard let session, let item = session.item else { return }
        
        for effect in session.effects {
            if let existingEffect = item.effects.first(where: { $0.effect.id == effect.effect.id }) {
                existingEffect.count -= 1
                existingEffect.totalIntensity -= effect.intensity
                if existingEffect.count == 0 {
                    modelContext.delete(existingEffect)
                }
            }
        }
        
        for flavor in session.flavors {
            if let existingFlavor = item.flavors.first(where: { $0.flavor.id == flavor.flavor.id }) {
                existingFlavor.count -= 1
                existingFlavor.totalIntensity -= (flavor.intensity ?? 0)
                if existingFlavor.count == 0 {
                    modelContext.delete(existingFlavor)
                }
            }
        }
    }*/
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Schema([Item.self, Strain.self]), configurations: config)
    
    let item = Item.sampleItem
    container.mainContext.insert(item)
    
    return NavigationStack {
        SessionDetailsView(session: item.sessions[0])
            .environment(ImageViewManager())
    }
}
