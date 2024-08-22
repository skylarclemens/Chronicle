//
//  ImageGridView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/22/24.
//

import SwiftUI

struct ImageGridView: View {
    var imagesData: [Data]?
    var spacing: CGFloat = 8
    var height: CGFloat = 200
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        if let imagesData {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let totalHeight = geometry.size.height
                
                let halfWidth = totalWidth * 0.5 - (spacing / 2)
                let halfHeight = (totalHeight - spacing) / 2
                let primaryWidth = imagesData.count == 1 ? totalWidth : halfWidth
                let secondaryWidth = halfWidth
                let tertiaryWidth = (halfWidth - spacing) / 2
                
                
                HStack(spacing: spacing) {
                    if let firstImage = imagesData.first, let uiImage = UIImage(data: firstImage) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: primaryWidth, height: totalHeight)
                            .clipShape(.rect(cornerRadius: cornerRadius))
                    }
                    if imagesData.count > 1 {
                        VStack(spacing: imagesData.count == 2 ? 0 : spacing) {
                            if imagesData.count >= 2 {
                                if let uiImage = UIImage(data: imagesData[1]) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: secondaryWidth, height: imagesData.count == 2 ? totalHeight : halfHeight)
                                        .clipShape(.rect(cornerRadius: cornerRadius))
                                }
                            }
                            HStack(spacing: spacing) {
                                if imagesData.count == 3 {
                                    if let uiImage = UIImage(data: imagesData[2]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: secondaryWidth, height: halfHeight)
                                            .clipShape(.rect(cornerRadius: cornerRadius))
                                    }
                                } else if imagesData.count >= 4 {
                                    if let uiImage = UIImage(data: imagesData[2]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: tertiaryWidth, height: halfHeight)
                                            .clipShape(.rect(cornerRadius: cornerRadius))
                                    }
                                    if let uiImage = UIImage(data: imagesData[3]) {
                                        ZStack {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: tertiaryWidth, height: halfHeight)
                                                .clipShape(.rect(cornerRadius: cornerRadius))
                                                .blur(radius: imagesData.count > 4 ? 5 : 0)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: cornerRadius)
                                                        .fill(.black.opacity(imagesData.count > 4 ? 0.15 : 0))
                                                )
                                            if imagesData.count > 4 {
                                                Text("+\(imagesData.indices.count - 3)")
                                                    .font(.system(.headline, design: .rounded))
                                            }
                                        }
                                        .clipShape(.rect(cornerRadius: cornerRadius))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: height)
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
    
    return ImageGridView(imagesData: imagesData)
}
