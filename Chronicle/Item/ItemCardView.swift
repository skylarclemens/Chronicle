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
        )
    }
}

#Preview {
    NavigationStack {
        ItemCardView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
}
