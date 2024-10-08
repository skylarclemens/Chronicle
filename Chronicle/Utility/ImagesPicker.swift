//
//  ImagesPicker.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/25/24.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

struct ImagesPicker: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var pickerItems: [PhotosPickerItem]
    @Binding var imagesData: [Data]
    
    @State private var showingCamera: Bool = false
    @State private var showingPhotosPicker: Bool = false
    @State private var cameraSelection: UIImage?
    
    public func body(content: Content) -> some View {
        content
        .confirmationDialog("Choose an option", isPresented: $isPresented) {
            Button("Camera") {
                showingCamera = true
            }
            .tint(.accent)
            Button("Select photos") {
                showingPhotosPicker = true
            }
            .tint(.accent)
        }
        .photosPicker(isPresented: $showingPhotosPicker, selection: $pickerItems, maxSelectionCount: 4, matching: .any(of: [.images, .not(.panoramas), .not(.videos)]))
        .fullScreenCover(isPresented: $showingCamera) {
            CameraPicker(isPresented: $showingCamera, image: $cameraSelection)
        }
        .onChange(of: pickerItems) { oldValues, newValues in
            Task {
                if pickerItems.count == 0 { return }
                
                for value in newValues {
                    if let imageData = try? await value.loadTransferable(type: Data.self) {
                        withAnimation {
                            imagesData.append(imageData)
                        }
                    }
                }
                
                pickerItems.removeAll()
            }
        }
        .onChange(of: cameraSelection) { oldValues, newValues in
            if let selection = cameraSelection,
               let selectionData = selection.pngData() {
                withAnimation {
                    imagesData.append(selectionData)
                }
                cameraSelection = nil
            }
        }
    }
}

extension View {
    public func imagesPicker(isPresented: Binding<Bool>, pickerItems: Binding<[PhotosPickerItem]>, imagesData: Binding<[Data]>) -> some View {
        modifier(ImagesPicker(isPresented: isPresented, pickerItems: pickerItems, imagesData: imagesData))
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let editedImage = info[.editedImage] as? UIImage
            let originalImage = info[.originalImage] as? UIImage
            
            if let currentImage = editedImage ?? originalImage {
                parent.image = currentImage
            }
            
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

#Preview {
    @Previewable @State var pickerItems: [PhotosPickerItem] = []
    @Previewable @State var imagesData: [Data] = []
    @Previewable @State var showingImagePicker: Bool = false
    
    VStack {}
        .imagesPicker(isPresented: $showingImagePicker, pickerItems: $pickerItems, imagesData: $imagesData)
}
