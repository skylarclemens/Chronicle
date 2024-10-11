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
                        .clipShape(.rect(cornerRadius: 8))
                }
                Text(item.name)
                if item.favorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
                Spacer()
                if let currentInventory = item.currentInventory {
                    HStack(spacing: 0) {
                        Text(currentInventory.value, format: .number)
                        Text(" \(currentInventory.unit.rawValue)")
                    }
                    .font(.subheadline)
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
