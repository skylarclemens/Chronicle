//
//  AccessoryDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct AccessoryDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var accessory: Accessory?
    
    @State private var isEditing = false
    @State private var isDeleting = false
    
    var body: some View {
        if let accessory {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            if let type = accessory.type {
                                Label(type.label().localizedCapitalized, systemImage: type.symbol())
                                .font(.footnote)
                                .infoPillStyle()
                            }
                            if let brand = accessory.brand {
                                Label(brand.localizedCapitalized, systemImage: "cart")
                                    .font(.footnote)
                                    .infoPillStyle()
                            }
                            Spacer()
                            if accessory.favorite {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .frame(height: 24)
                        ImageCarouselView(imagesData: accessory.imagesData)
                            .padding(.top)
                    }
                    .padding(.horizontal)
                    if let purchase = accessory.purchase {
                        PurchaseRowView(purchase: purchase)
                            .padding(.horizontal)
                    }
                    if let sessions = accessory.sessions,
                        !sessions.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Recent Sessions")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            VStack(alignment: .leading) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(accessory.mostRecentSessions()) { session in
                                            NavigationLink {
                                                SessionDetailsView(session: session)
                                            } label: {
                                                CompactSessionCardView(session: session, showTime: false)
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
                
            }
            .navigationTitle(accessory.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Options", systemImage: "ellipsis") {
                        Section {
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
                        Button {
                            accessory.favorite.toggle()
                            do {
                                try modelContext.save()
                            } catch {
                                print("Failed to save model context.")
                            }
                        } label: {
                            Label(accessory.favorite ? "Unfavorite" : "Favorite", systemImage: accessory.favorite ? "star.slash": "star")
                        }
                    }
                }
            }
            .alert("Are you sure you want to delete \(accessory.name)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    delete(accessory)
                }
            }
            .sheet(isPresented: $isEditing) {
                AccessoryEditorView(accessory: accessory)
            }
        }
    }
    
    private func delete(_ accessory: Accessory) {
        modelContext.delete(accessory)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AccessoryDetailsView(accessory: SampleData.shared.accessory)
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
