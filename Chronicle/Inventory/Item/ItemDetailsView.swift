//
//  ItemDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/14/24.
//

import SwiftUI
import SwiftData

struct ItemDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var item: Item?
    
    @State private var isEditing = false
    @State private var isDeleting = false
    @State private var currentImageIndex = 0
    
    var moodTypes: [MoodType: Int] {
        var counts: [MoodType: Int] = [:]
        if let item,
           let sessions = item.sessions {
            for session in sessions {
                if let moodType = session.mood?.type {
                    counts[moodType, default: 0] += 1
                }
            }
        }
        return counts
    }
    
    var body: some View {
        if let item {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            if let itemType = item.type {
                                Text(itemType.label())
                                    .font(.footnote)
                                    .infoPillStyle()
                            }
                            if let strain = item.strain,
                               let strainType = strain.type {
                                Text(strainType.rawValue.localizedCapitalized)
                                    .font(.footnote)
                                    .infoPillStyle()
                                HStack {
                                    Image(systemName: "leaf")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.accent)
                                    Text(strain.name)
                                }
                                    .font(.footnote)
                                    .infoPillStyle(.accent)
                            }
                            Spacer()
                            if item.favorite {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .frame(height: 24)
                        ImageGridView(imagesData: item.imagesData)
                            .padding(.top)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text("Details")
                            .headerTitle()
                        VStack(alignment: .leading) {
                            if let currentInventory = item.currentInventory {
                                HStack(spacing: 0) {
                                    Text("Current Amount")
                                    Spacer()
                                    Text(currentInventory.value, format: .number)
                                    Text(" \(currentInventory.unit.rawValue)")
                                }
                                .padding(.trailing)
                                .padding(.vertical, 6)
                                Divider()
                            }
                            NavigationLink {
                                TransactionHistoryView(item: item)
                            } label: {
                                HStack {
                                    Text("View Amount History")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.trailing)
                            .padding(.vertical, 6)
                        }
                        .padding(.vertical, 8)
                        .padding(.leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground),
                                    in: .rect(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    if let sessions = item.sessions,
                        !sessions.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Moods")
                                .headerTitle()
                                .padding(.horizontal)
                            ItemMoodInsightsView(item: item)
                        }
                        VStack(alignment: .leading) {
                            Text("Recent Sessions")
                                .headerTitle()
                                .padding(.horizontal)
                            VStack(alignment: .leading) {
                                ScrollView(.horizontal) {
                                    LazyHStack {
                                        ForEach(item.mostRecentSessions()) { session in
                                            NavigationLink {
                                                SessionDetailsView(session: session, fromItem: true)
                                            } label: {
                                                CompactSessionCardView(session: session, showTime: false)
                                            }
                                            .tint(.primary)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .scrollIndicators(.hidden)
                                .scrollClipDisabled()
                            }
                        }
                    }
                    if !item.purchases.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Purchases")
                                .headerTitle()
                            VStack(alignment: .leading) {
                                PurchaseRowView(purchase: item.purchases.first?.purchase)
                                if item.purchases.count > 1 {
                                    NavigationLink {
                                        ScrollView {
                                            VStack {
                                                ForEach(item.purchases) { transaction in
                                                    PurchaseRowView(purchase: transaction.purchase)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .padding(.top, 12)
                                        .navigationTitle("Purchases")
                                    } label: {
                                        HStack {
                                            Text("View all purchases")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                    }
                                    .tint(.accent)
                                    .padding()
                                    .background(.accent.opacity(0.15),
                                                in: RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground),
                                        in: RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                    }
                    if !item.compounds.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Composition")
                                .headerTitle()
                            if !item.cannabinoids.isEmpty {
                                DetailSection(header: "Cannabinoids", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(item.cannabinoids) { cannabinoid in
                                                HStack(spacing: 12) {
                                                    Text(cannabinoid.name)
                                                        .bold()
                                                    Text(cannabinoid.value, format: .percent)
                                                        .foregroundStyle(.secondary)
                                                }
                                                .pillStyle()
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .scrollIndicators(.hidden)
                                }
                            }
                            if !item.terpenes.isEmpty {
                                DetailSection(header: "Terpenes", isScrollView: true) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(item.terpenes) { terpene in
                                                TerpeneView(terpene)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .scrollIndicators(.hidden)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    if let tags = item.tags,
                        !tags.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags")
                                .headerTitle()
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(tags) { tag in
                                        Text(tag.name)
                                            .tagStyle()
                                    }
                                }
                            }
                            .contentMargins(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.secondarySystemGroupedBackground),
                                        in: RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
            }
            .navigationTitle(item.name)
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
                            item.favorite.toggle()
                            do {
                                try modelContext.save()
                            } catch {
                                print("Failed to save model context.")
                            }
                        } label: {
                            Label(item.favorite ? "Unfavorite" : "Favorite", systemImage: item.favorite ? "star.slash": "star")
                        }
                    }
                }
            }
            .alert("Are you sure you want to delete \(item.name)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    delete(item)
                }
            }
            .sheet(isPresented: $isEditing) {
                ItemEditorView(item: item)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
        } else {
            ContentUnavailableView("Item unavailable", systemImage: "tray")
        }
    }
    
    private func delete(_ item: Item) {
        modelContext.delete(item)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ItemDetailsView(item: SampleData.shared.item)
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
