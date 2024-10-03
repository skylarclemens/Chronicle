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
    var imageHeight: CGFloat = 45
    var imageWidth: CGFloat = 45
    
    var body: some View {
        HStack {
            if let imagesData = item.imagesData, !imagesData.isEmpty,
               let uiImage = UIImage(data: imagesData[0]) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: imageWidth, height: imageHeight)
                .cornerRadius(8)
                .clipped()
            }
            Text(item.name)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
            if item.favorite {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.accent)
            }
        }
        .padding(8)
        .frame(maxHeight: 60, alignment: .leading)
        .background(.thickMaterial)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.primary.opacity(0.1), lineWidth: 1)
                .allowsHitTesting(false)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        ItemCardView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
}
