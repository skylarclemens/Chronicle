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
    let item: Item
    
    var body: some View {
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
