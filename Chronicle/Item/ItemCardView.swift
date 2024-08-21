//
//  ItemCardView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/19/24.
//

import SwiftUI
import SwiftData

struct ItemCardView: View {
    let item: Item
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.headline)
                    .bold()
                Text(item.type.label())
                    .font(.footnote)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.bar ,lineWidth: 1)
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
        .frame(width: 220, height: 120)
        .background {
            if let imagesData = item.imagesData, !imagesData.isEmpty,
               let uiImage = UIImage(data: imagesData[0]) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    )
            }
        }
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.bar, lineWidth: 1)
                .allowsHitTesting(false)
        )
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
        ItemCardView(item: item)
    }
}
