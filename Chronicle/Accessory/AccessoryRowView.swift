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
                        .clipShape(.rect(cornerRadius: 4))
                } else {
                    Image(systemName: accessory.type?.symbol() ?? "wrench.and.screwdriver")
                        .frame(width: 45, height: 45)
                        .foregroundStyle(.accent)
                        .background(.accent.opacity(0.15),
                                    in: RoundedRectangle(cornerRadius: 4))
                }
                Text(accessory.name)
                Spacer()
                if accessory.favorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
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
