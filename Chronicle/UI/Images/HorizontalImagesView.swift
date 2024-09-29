//
//  HorizontalImagesView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/5/24.
//

import SwiftUI

struct HorizontalImagesView: View {
    @Environment(ImageViewManager.self) var imageViewManager
    var imagesData: [Data]
    var rotateImages: Bool = false
    var showAllImages: Bool = false
    var maxImageAmount: Int = 4
    var allowImageViewer: Bool = true
    
    var imagesToShow: [Data] {
        if showAllImages {
            return imagesData
        }
        return Array(imagesData.prefix(maxImageAmount))
    }
    
    var body: some View {
        if !imagesToShow.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: rotateImages ? -18 : 8) {
                    Spacer()
                    ForEach(Array(imagesToShow.enumerated()), id: \.offset) { (index, imageData) in
                        let isLastImage = index == imagesToShow.count - 1 && !showAllImages && index < imagesData.count - 1
                        if let uiImage = UIImage(data: imageData) {
                            let firstRotate: Double = index % 2 == 0 ? -6 : 2
                            let secondRotate: Double = index % 2 == 0 ? -2 : 6
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 110, maxHeight: 140, alignment: .topLeading)
                                .blur(radius: isLastImage ? 2 : 0, opaque: true)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .clipped()
                                .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 2)
                                .overlay {
                                    if isLastImage {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.black.opacity(0.33))
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(.primary.opacity(0.15))
                                )
                                .offset(x: 0, y: secondRotate/2)
                                .zIndex(Double(-index))
                                .overlay {
                                    if isLastImage {
                                        Text("+\(imagesData.count - imagesToShow.count)")
                                            .font(.system(.title2, design: .rounded, weight: .semibold))
                                    }
                                }
                                .contentShape(RoundedRectangle(cornerRadius: 12))
                                .rotationEffect(rotateImages ? .degrees(Double.random(in: firstRotate...secondRotate)) : .zero)
                                .onTapGestureIf(allowImageViewer) {
                                    imageViewManager.imagesToShow = imagesData
                                    imageViewManager.selectedImage = index
                                    imageViewManager.showImageViewer = true
                                    print("clicked \(index)")
                                }
                        }
                    }
                    Spacer()
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollClipDisabled()
        }
    }
}

#Preview {
    HorizontalImagesView(imagesData: Item.sampleImages + Item.sampleImages + Item.sampleImages, rotateImages: true)
        .environment(ImageViewManager())
}
