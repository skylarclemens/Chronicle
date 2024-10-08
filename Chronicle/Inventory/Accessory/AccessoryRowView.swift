//
//  AccessoryRowView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct AccessoryRowView: View {
    var accessory: Accessory?
    var body: some View {
        if let accessory {
            HStack {
                if let imagesData = accessory.imagesData, !imagesData.isEmpty,
                   let uiImage = UIImage(data: imagesData[0]) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(.rect(cornerRadius: 8))
                } else if let accessoryType = accessory.type {
                    Image(systemName: accessoryType.symbol())
                        .frame(width: 45, height: 45)
                        .foregroundStyle(.accent)
                        .background(.accent.opacity(0.15),
                                    in: RoundedRectangle(cornerRadius: 8))
                }
                Text(accessory.name)
                if accessory.favorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    List {
        AccessoryRowView(accessory: SampleData.shared.accessory)
    }
    .modelContainer(SampleData.shared.container)
}
