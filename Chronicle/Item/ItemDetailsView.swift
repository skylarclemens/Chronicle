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
                            if let strain = item.strain {
                                Text(strain.type.rawValue.localizedCapitalized)
                                    .font(.footnote)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThickMaterial))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.tertiary ,lineWidth: 1)
                                    )
                            }
                            Text(item.type.label())
                                .font(.footnote)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThickMaterial))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(.tertiary ,lineWidth: 1)
                                )
                        }
                        if let imagesData = item.imagesData, !imagesData.isEmpty {
                            TabView(selection: $currentImageIndex) {
                                ForEach(0..<imagesData.count, id: \.self) { imageIndex in
                                    if let uiImage = UIImage(data: imagesData[imageIndex]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .tag(imageIndex)
                                    }
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .automatic))
                            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                            .frame(maxHeight: 200)
                            .frame(height: 200)
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(.bar)
                                    .allowsHitTesting(false)
                            )
                            .padding(.vertical)
                        }
                        if let strain = item.strain {
                            Text(strain.name)
                        }
                    }
                    .padding(.horizontal)
                    if !item.flavors.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Flavors")
                                .font(.headline)
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
                            .padding(.vertical)
                            .background(.regularMaterial,
                                        in: RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal)
                    }
                    
                    if !item.effects.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Effects")
                                .font(.headline)
                            if !sortedMoodEffects.isEmpty {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Moods")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("Avg. intensity")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
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
                                .padding()
                                .background(.regularMaterial,
                                            in: RoundedRectangle(cornerRadius: 10))
                            }
                            if !sortedWellnessEffects.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Wellness")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal)
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
                                .padding(.vertical)
                                .background(.regularMaterial,
                                            in: RoundedRectangle(cornerRadius: 10))
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
