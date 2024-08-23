//
//  ImageViewerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/23/24.
//

import SwiftUI

struct ImageViewerView: View {
    @Environment(ImageViewManager.self) var imageViewManager
    
    var body: some View {
        if let imagesData = imageViewManager.imagesToShow, !imagesData.isEmpty {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                TabView(selection: imageViewManager.selectedImageBinding) {
                    ForEach(0..<imagesData.count, id: \.self) { imageIndex in
                        if let uiImage = UIImage(data: imagesData[imageIndex]) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(imageIndex)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            }
            .overlay(alignment: .topTrailing) {
                Button("", systemImage: "xmark.circle.fill") {
                    imageViewManager.showImageViewer = false
                    imageViewManager.selectedImage = 0
                    imageViewManager.imagesToShow = nil
                }
                .font(.title)
                .foregroundStyle(.primary, .tertiary)
                .padding(4)
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
    @State var imageViewManager = ImageViewManager(selectedImage: 0, showImageViewer: true, imagesToShow: imagesData)
    
    return ImageViewerView()
        .environment(imageViewManager)
}
