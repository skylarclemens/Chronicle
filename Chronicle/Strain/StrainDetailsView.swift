//
//  StrainDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI

struct StrainDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var strain: Strain?
    @State private var isEditing = false
    @State private var isDeleting = false
    
    var body: some View {
        if let strain {
            VStack {
                HStack {
                    Image(systemName: "leaf")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(.regularMaterial))
                        .foregroundStyle(.accent)
                    Text(strain.name)
                }
            }
            .toolbar {
                Menu("Options", systemImage: "ellipsis") {
                    Button {
                        isEditing = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        isDeleting = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .alert("Are you sure you want to delete \(strain.name)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    delete(strain)
                }
            }
            .sheet(isPresented: $isEditing) {
                StrainEditorView(strain: strain)
            }
        } else {
            ContentUnavailableView("Strain unavailable", systemImage: "leaf")
        }
    }
    
    private func delete(_ strain: Strain) {
        modelContext.delete(strain)
        dismiss()
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addStrainExamples(sampleStrains: Strain.sampleStrains)
    
    return NavigationStack {
        StrainDetailsView(strain: Strain.sampleStrains[0])
    }
}
