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
                Spacer()
                if item.favorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            ItemRowView(item: SampleData.shared.item)
        }
    }
    .modelContainer(SampleData.shared.container)
}
