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
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ForEach(imagesData, id: \.self) { data in
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150, alignment: .leading)
                                        .clipShape(.rect(cornerRadius: 10))
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 160)
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
            ContentUnavailableView("Select an item", systemImage: "tray")
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
        
        let item = Item(name: "Dream Gummies", type: .edible)
        container.mainContext.insert(item)
        let strain = Strain(name: "Blue Dream", type: .hybrid)
        container.mainContext.insert(strain)
        
        if let imageData {
            item.imagesData = [imageData]
        }
        item.strain = strain
        
        return NavigationStack {
            ItemDetailsView(item: item)
                .modelContainer(container)
        }
    }
}
