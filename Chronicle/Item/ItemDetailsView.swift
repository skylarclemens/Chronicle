//
//  ItemDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/14/24.
//

import SwiftUI
import SwiftData

struct ItemDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var item: Item?
    @State private var isDeleting = false
    @State private var currentImageIndex = 0
    
    var sortedMoodEffects: [ItemEffect] {
        let moods = item?.effects.filter { $0.effect.type == .mood }
        return moods?.sorted {
            $0.averageIntensity > $1.averageIntensity
        } ?? []
    }
    
    var sortedWellnessEffects: [ItemEffect] {
        let wellness = item?.effects.filter { $0.effect.type == .wellness }
        return wellness?.sorted {
            $0.averageIntensity > $1.averageIntensity
        } ?? []
    }
    
    var body: some View {
        if let item {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.type.label())
                                .font(.footnote)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThickMaterial,
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
                                HStack {
                                    Image(systemName: "leaf")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.accent)
                                    Text(strain.name)
                                }
                                    .font(.footnote)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.accent.opacity(0.2),
                                                in: RoundedRectangle(cornerRadius: 24))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.tertiary, lineWidth: 1)
                                    )
                            }
                        }
                        ImageCarouselView(imagesData: item.imagesData)
                    }
                    .padding(.horizontal)
                    if !item.flavors.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Flavors")
                                .font(.headline)
                            DetailSection(isScrollView: true) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(item.sortedFlavors) { flavor in
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
                        .padding(.horizontal)
                    }
                    
                    if !item.effects.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Effects")
                                .font(.headline)
                            if !sortedMoodEffects.isEmpty {
                                DetailSection(header:"Moods", headerRight: "Avg. intensity") {
                                    ForEach(sortedMoodEffects) { effect in
                                        HStack {
                                            Text(effect.effect.emoji)
                                                .font(.system(size: 14))
                                            Text(effect.effect.name)
                                                .font(.footnote)
                                                .fontWeight(.medium)
                                                .frame(width: 80, alignment: .leading)
                                            Spacer()
                                            ProgressView(value: effect.averageIntensity/10)
                                            Text(effect.averageIntensity, format: .number)
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
                        .padding()
                    }
                    
                    if !item.sessions.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Sessions")
                                .font(.headline)
                                .padding(.horizontal)
                            VStack(alignment: .leading) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(item.sessions) { session in
                                            CompactSessionCardView(session: session)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(item.name)
            .toolbar {
                Menu("Options", systemImage: "ellipsis") {
                    Button(role: .destructive) {
                        isDeleting = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                
            }
            .alert("Are you sure you want to delete \(item.name)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    delete(item)
                }
            }
        } else {
            ContentUnavailableView("Item unavailable", systemImage: "tray")
        }
    }
    
    private func delete(_ item: Item) {
        modelContext.delete(item)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Schema([Item.self, Strain.self]), configurations: config)
    
    let item = Item.sampleItem
    container.mainContext.insert(item)
    
    return NavigationStack {
        ItemDetailsView(item: item)
            .modelContainer(container)
    }
}
