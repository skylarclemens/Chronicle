//
//  ImageViewManager.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/23/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
public class ImageViewManager {
    var selectedImage: Int
    var showImageViewer: Bool
    var imagesToShow: [Data]?
    
    var selectedImageBinding: Binding<Int> {
        Binding(
            get: { self.selectedImage },
            set: { self.selectedImage = $0 }
        )
    }
    
    init(selectedImage: Int = 0, showImageViewer: Bool = false, imagesToShow: [Data]? = nil) {
        self.selectedImage = selectedImage
        self.showImageViewer = showImageViewer
        self.imagesToShow = imagesToShow
    }
}
