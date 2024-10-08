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
            ScrollView {
                VStack(spacing: 24) {
                    HStack(alignment: .center) {
                        if let type = strain.type {
                            Text(type.rawValue.localizedCapitalized)
                                .font(.footnote)
                                .infoPillStyle()
                        }
                        Spacer()
                        if strain.favorite {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.accent)
                        }
                    }
                    .frame(height: 24)
                    .padding(.horizontal)
                    if !strain.desc.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.title2)
                                .fontWeight(.semibold)
                            DetailSection {
                                Text(strain.desc)
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                    }
                    if let items = strain.items,
                        !items.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Related Items")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(items) { item in
                                        NavigationLink {
                                            ItemDetailsView(item: item)
                                        } label: {
                                            ItemCardView(item: item)
                                        }
                                        .tint(.primary)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .contentMargins(.horizontal, 16)
                        }
                    }
                }
                
            }
            .navigationTitle(strain.name)
            .navigationBarTitleDisplayMode(.large)
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
    return NavigationStack {
        StrainDetailsView(strain: SampleData.shared.strain)
    }
    .modelContainer(SampleData.shared.container)
}
