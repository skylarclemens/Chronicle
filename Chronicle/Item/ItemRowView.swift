//
//  ItemRowView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct ItemRowView: View {
    var item: Item?
    var body: some View {
        if let item {
            HStack {
                if let imagesData = item.imagesData, !imagesData.isEmpty,
                   let uiImage = UIImage(data: imagesData[0]) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(.rect(cornerRadius: 4))
                }
                Text(item.name)
            }
        }
    }
}

#Preview {
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
        List {
            ItemRowView(item: item)
        }
    }
}
