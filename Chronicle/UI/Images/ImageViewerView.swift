//
//  ImageViewerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/23/24.
//

import SwiftUI

struct ImageViewerView: View {
    @Environment(ImageViewManager.self) var imageViewManager
    
    @State private var currentMagnify = 0.0
    @State private var finalMagnify = 1.0
    
    var body: some View {
        if let imagesData = imageViewManager.imagesToShow, !imagesData.isEmpty {
            ZStack {
                Rectangle()
                    .fill(.regularMaterial)
                    .ignoresSafeArea()
                TabView(selection: imageViewManager.selectedImageBinding) {
                    ForEach(0..<imagesData.count, id: \.self) { imageIndex in
                        if let uiImage = UIImage(data: imagesData[imageIndex]) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(finalMagnify + currentMagnify)
                                .gesture(
                                    MagnifyGesture()
                                        .onChanged { value in
                                            currentMagnify = value.magnification - 1
                                        }
                                        .onEnded { value in
                                            withAnimation {
                                                let val = finalMagnify + currentMagnify
                                                if val < 1.0 {
                                                    finalMagnify = 1.0
                                                } else {
                                                    finalMagnify = val
                                                }
                            
                                                currentMagnify = 0
                                            }
                                        }

                                )
                                .tag(imageIndex)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            }
            .overlay(alignment: .topTrailing) {
                Button("", systemImage: "xmark.circle.fill") {
                    withAnimation {
                        imageViewManager.showImageViewer = false
                    }
                }
                .buttonStyle(.close)
            }
        }
    }
}

#Preview {
    var imagesData: [Data] = []
    let imageData = UIImage(named: "edibles-jar")?.pngData()
    let imageData2 = UIImage(named: "pre-roll")?.pngData()
    let imageData3 = UIImage(named: "pre-roll")?.pngData()
    let imageData4 = UIImage(named: "edibles-jar")?.pngData()
    let imageData5 = UIImage(named: "edibles-jar")?.pngData()
    if let imageData, let imageData2, let imageData3, let imageData4, let imageData5 {
        imagesData = [imageData, imageData2, imageData3, imageData4, imageData5]
    }
    
    return ImageViewerView()
        .environment(ImageViewManager(selectedImage: 0, showImageViewer: true, imagesToShow: imagesData))
}
