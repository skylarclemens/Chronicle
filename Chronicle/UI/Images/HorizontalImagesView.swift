//
//  HorizontalImagesView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/5/24.
//

import SwiftUI

struct HorizontalImagesView: View {
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
                                .frame(width: 120, height: 150, alignment: .leading)
                                .clipShape(.rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(.ultraThinMaterial)
                                )
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        selectedImagesData.remove(at: selectedImagesData.firstIndex(of: imageData)!)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .padding(4)
                                            .font(.title2)
                                            .foregroundStyle(.primary, Color(UIColor.systemFill))
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
    HorizontalImagesView(selectedImagesData: .constant(Item.sampleImages), rotateImages: true)
}
