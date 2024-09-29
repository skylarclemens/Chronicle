//
//  EditableHorizontalImagesView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/29/24.
//

import SwiftUI

struct EditableHorizontalImagesView: View {
    @Binding var selectedImagesData: [Data]
    var rotateImages: Bool = false
    
    var body: some View {
        if selectedImagesData.count > 0 {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: rotateImages ? -18 : 8) {
                    ForEach(Array(selectedImagesData.enumerated()), id: \.offset) { (index, imageData) in
                        if let uiImage = UIImage(data: imageData) {
                            let firstRotate: Double = index % 2 == 0 ? -6 : 2
                            let secondRotate: Double = index % 2 == 0 ? -2 : 6
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 140, alignment: .leading)
                                .clipShape(.rect(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(.primary.opacity(0.15))
                                )
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        selectedImagesData.remove(at: selectedImagesData.firstIndex(of: imageData)!)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .padding(4)
                                            .imageScale(.large)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .regularMaterial)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 2)
                                .offset(x: 0, y: secondRotate/2)
                                .rotationEffect(rotateImages ? .degrees(Double.random(in: firstRotate...secondRotate)) : .zero)
                                .zIndex(Double(-index))
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollClipDisabled()
        }
    }
}


#Preview {
    @Previewable @State var imagesData: [Data] = Item.sampleImages
    EditableHorizontalImagesView(selectedImagesData: $imagesData, rotateImages: true)
        .modelContainer(SampleData.shared.container)
}
