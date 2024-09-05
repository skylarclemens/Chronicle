//
//  ImagePickerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/5/24.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var selectedImagesData: [Data]
    
    var body: some View {
        if selectedImagesData.count > 0 {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(selectedImagesData, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150, alignment: .leading)
                                .clipShape(.rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.bar)
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
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 16)
        }
    }
}

#Preview {
    ImagePickerView(selectedImagesData: .constant([]))
}
