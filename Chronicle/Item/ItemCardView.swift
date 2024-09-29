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
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(item.name)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    Spacer()
                    if item.favorite {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.accent)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
        }
        .frame(width: 180, height: 80)
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
                .strokeBorder(.white.opacity(0.15))
        )
    }
}

#Preview {
    NavigationStack {
        ItemCardView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
}
