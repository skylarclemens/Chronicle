//
//  ImageCarouselView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import SwiftUI

struct ImageCarouselView: View {
    var imagesData: [Data]?
    @State private var currentImageIndex = 0
    
    var body: some View {
        if let imagesData, !imagesData.isEmpty {
            TabView(selection: $currentImageIndex) {
                ForEach(0..<imagesData.count, id: \.self) { imageIndex in
                    if let uiImage = UIImage(data: imagesData[imageIndex]) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .tag(imageIndex)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .frame(maxHeight: 200)
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.bar)
                    .allowsHitTesting(false)
            )
            .padding(.vertical)
        }
    }
}

#Preview {
    var imagesData: [Data] = []
    let imageData = UIImage(named: "edibles-jar")?.pngData()
    let imageData2 = UIImage(named: "pre-roll")?.pngData()
    if let imageData, let imageData2 {
        imagesData = [imageData, imageData2]
    }
    
    return ImageCarouselView(imagesData: imagesData)
}
