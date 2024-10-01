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
        if let item {
            for session in item.sessions {
                if let moodType = session.mood?.type {
                    counts[moodType, default: 0] += 1
                }
            }
        }
        return counts
    }
    
    var topEmotions: [Emotion: Int] {
        var counts: [Emotion: Int] = [:]
        if let item {
            for mood in item.moods {
                for emotion in mood.emotions {
                    counts[emotion, default: 0] += 1
                }
            }
        }
        return counts.sorted { $0.value > $1.value }.prefix(5).reduce(into: [:]) {
            $0[$1.key] = $1.value
        }
    }
    
    var body: some View {
        if let item {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(item.type.label())
                                .font(.footnote)
                                .infoPillStyle()
                            if let strain = item.strain {
                                Text(strain.type.rawValue.localizedCapitalized)
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
                            .font(.title2)
                            .fontWeight(.semibold)
                        DetailSection(header: "Amount") {} headerRight: {
                            HStack(spacing: 0) {
                                Text(item.remainingAmount, format: .number)
                                Text(" \(item.unit ?? "")")
                            }
                        }
                        if !item.compounds.isEmpty {
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
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 12)
                                                .background(Color(.systemGroupedBackground),
                                                            in: RoundedRectangle(cornerRadius: 12))
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
                    }
                    .padding(.horizontal)
                    if !item.sessions.isEmpty {
                        if !item.moods.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Moods")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(MoodType.allCases, id: \.self) { moodType in
                                            if let count = moodTypes[moodType] {
                                                HStack {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .frame(maxWidth: 3, maxHeight: 14)
                                                        .foregroundStyle(moodType.color)
                                                    Text(moodType.label)
                                                    Text(count, format: .number)
                                                        .font(.footnote)
                                                        .fontWeight(.semibold)
                                                        .fontDesign(.rounded)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(.background.opacity(0.33),
                                                                    in: RoundedRectangle(cornerRadius: 8))
                                                }
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 10)
                                                .background(moodType.color.opacity(0.33),
                                                            in: RoundedRectangle(cornerRadius: 12))
                                            }
                                        }
                                    }
                                }
                                .contentMargins(.horizontal, 16)
                                DetailSection(header: "Top Feelings") {
                                    ForEach(Array(topEmotions.keys), id: \.id) { emotion in
                                        if let count = topEmotions[emotion] {
                                            HStack {
                                                if let emoji = emotion.emoji {
                                                    Text(emoji)
                                                }
                                                Text(emotion.name)
                                                Spacer()
                                                Text(count, format: .number)
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                } headerRight: {
                                    Text("Count")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Recent Sessions")
                                .font(.title2)
                                .fontWeight(.semibold)
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
                            }
                        }
                    }
                    if !item.purchases.isEmpty {
                        
                        VStack(alignment: .leading) {
                            Text("Purchases")
                                .font(.title2)
                                .fontWeight(.semibold)
                            VStack(alignment: .leading) {
                                PurchaseRowView(purchase: item.purchases.first)
                                if item.purchases.count > 1 {
                                    NavigationLink {
                                        ScrollView {
                                            VStack {
                                                ForEach(item.purchases) { purchase in
                                                    PurchaseRowView(purchase: purchase)
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
                    if !item.tags.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags")
                                .font(.title2)
                                .fontWeight(.semibold)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(item.tags) { tag in
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
