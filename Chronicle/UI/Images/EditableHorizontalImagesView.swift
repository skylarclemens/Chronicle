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
    /*@Environment(ImageViewManager.self) var imageViewManager
    @Binding var selectedImagesData: [Data]
    var imagesData: [Data]
    var rotateImages: Bool
    var showAllImages: Bool
    var maxImageAmount: Int
    var editable: Bool
    var allowImageViewer: Bool
    
    var imagesToShow: [Data] {
        if showAllImages {
            return selectedImagesData
        }
        return Array(imagesData.prefix(maxImageAmount))
    }
    
    var body: some View {
        if !imagesToShow.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: rotateImages ? -18 : 8) {
                    Spacer()
                    ForEach(Array(imagesToShow.enumerated()), id: \.offset) { (index, imageData) in
                        let isLastImage = index == imagesToShow.count - 1 && !showAllImages
                        if let uiImage = UIImage(data: imageData) {
                            let firstRotate: Double = index % 2 == 0 ? -6 : 2
                            let secondRotate: Double = index % 2 == 0 ? -2 : 6
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 140, alignment: .leading)
                                .clipShape(.rect(cornerRadius: 12))
                                .overlay(alignment: .topTrailing) {
                                    if editable {
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
                                }
                                .overlay {
                                    if isLastImage {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.black.opacity(0.33))
                                    }
                                }
                                .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 2)
                                .offset(x: 0, y: secondRotate/2)
                                .blur(radius: isLastImage ? 2 : 0, opaque: true)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(.primary.opacity(0.15))
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .zIndex(Double(-index))
                                .overlay {
                                    if isLastImage,
                                       index < imagesData.count - 1 {
                                        Text("+\(imagesData.count - imagesToShow.count)")
                                            .font(.system(.title2, design: .rounded, weight: .semibold))
                                    }
                                }
                                .onTapGestureIf(allowImageViewer) {
                                    imageViewManager.imagesToShow = selectedImagesData
                                    imageViewManager.selectedImage = index
                                    imageViewManager.showImageViewer = true
                                    print("clicked \(index)")
                                }
                                .rotationEffect(rotateImages ? .degrees(Double.random(in: firstRotate...secondRotate)) : .zero)
                        }
                    }
                    Spacer()
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollClipDisabled()
        }
    }
    
    init(selectedImagesData: Binding<[Data]>? = nil,
         imagesData: [Data]? = nil,
         rotateImages: Bool = false,
         showAllImages: Bool = true,
         maxImageAmount: Int = 4,
         editable: Bool = true,
         allowImageViewer: Bool = false) {
        self._selectedImagesData = selectedImagesData ?? Binding.constant([])
        self.imagesData = imagesData ?? []
        self.rotateImages = rotateImages
        self.showAllImages = showAllImages
        self.maxImageAmount = maxImageAmount
        self.editable = editable
        self.allowImageViewer = allowImageViewer
    }*/
}


#Preview {
    @Previewable @State var imagesData: [Data] = Item.sampleImages
    EditableHorizontalImagesView(selectedImagesData: $imagesData, rotateImages: true)
        .modelContainer(SampleData.shared.container)
}
