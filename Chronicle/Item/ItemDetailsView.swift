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
    
    var body: some View {
        if let item {
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
                
                Spacer()
            }
            .padding(.horizontal)
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
    MainActor.assumeIsolated {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Schema([Item.self, Strain.self]), configurations: config)
        
        let imageData = UIImage(named: "edibles-jar")?.pngData()
        let imageData2 = UIImage(named: "pre-roll")?.pngData()
        
        let item = Item(name: "Dream Gummies", type: .edible)
        container.mainContext.insert(item)
        let strain = Strain(name: "Blue Dream", type: .hybrid)
        container.mainContext.insert(strain)
        
        if let imageData, let imageData2 {
            item.imagesData = [imageData, imageData2]
        }
        item.strain = strain
        
        return NavigationStack {
            ItemDetailsView(item: item)
                .modelContainer(container)
        }
    }
}
