//
//  SearchView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/3/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var sessions: [Session]
    @Query private var items: [Item]
    @Query private var tags: [Tag]
    
    @Binding var selectedSession: Session?
    
    @State private var searchText = ""
    
    @State private var openItemFilter: Bool = false
    @State private var selectedItems = Set<Item>()
    
    @State private var openTagFilter: Bool = false
    @State private var selectedTags = Set<Tag>()
    
    var filteredSessions: [Session] {
        return sessions.filter { session in
            let matchesSearch = searchText.isEmpty || session.title.localizedStandardContains(searchText)
            
            let matchesItems = selectedItems.isEmpty || (session.item != nil && selectedItems.contains(session.item!))
            let matchesTags = selectedTags.isEmpty || !selectedTags.isDisjoint(with: Set(session.tags))
            let matchesFilter = matchesItems && matchesTags
            
            return matchesSearch && matchesFilter
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Button("Clear") {
                            withAnimation {
                                clearFilters()
                            }
                        }
                        .font(.subheadline)
                        .buttonStyle(.editorInput)
                        Button {
                            openItemFilter = true
                        } label: {
                            if !selectedItems.isEmpty {
                                Text("\(selectedItems.count) items")
                                    .font(.subheadline)
                            } else {
                                Text("Items")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.editorInput)
                        Button {
                            openTagFilter = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "tag.fill")
                                    .foregroundStyle(.secondary)
                                if !selectedTags.isEmpty {
                                    Text("\(selectedTags.count) tags")
                                        .font(.subheadline)
                                } else {
                                    Text("Tags")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .font(.subheadline)
                        }
                        .buttonStyle(.editorInput)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
                Divider()
                ScrollView {
                    HStack {
                        Text("Results")
                            .font(.title3.bold())
                        Spacer()
                        Text("^[\(filteredSessions.count) sessions](inflect: true)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    LazyVStack {
                        ForEach(filteredSessions) { session in
                            Button {
                                dismiss()
                                selectedSession = session
                            } label: {
                                SessionRowView(session: session)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .contentMargins(.all, 16)
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Search Journal")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search sessions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
            }
            .sheet(isPresented: $openItemFilter) {
                ItemFilterView(selectedItems: $selectedItems, items: items)
            }
            .sheet(isPresented: $openTagFilter) {
                TagFilterView(selectedTags: $selectedTags, tags: tags)
            }
        }
    }
    
    private func clearFilters() {
        selectedItems = []
        selectedTags = []
    }
}

struct ItemFilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedItems: Set<Item>
    let items: [Item]
    
    @State private var localSelectedItems = Set<Item>()
    @State private var searchText: String = ""
    
    var sortedItems: [Item] {
        items.sorted {
            if $0.favorite > $1.favorite {
                return $0.name.localizedLowercase < $1.name.localizedLowercase
            }
            return $0.favorite > $1.favorite
        }
    }
    var filteredItems: [Item] {
        if !searchText.isEmpty {
            return sortedItems.filter {
                $0.name.localizedStandardContains(searchText)
            }
        }
        return sortedItems
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if !localSelectedItems.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(localSelectedItems)) { item in
                                Button {
                                    withAnimation {
                                        if localSelectedItems.contains(item) {
                                            localSelectedItems.remove(item)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(item.name)
                                            .font(.footnote)
                                        Image(systemName: "xmark")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.editorInput)
                            }
                        }
                    }
                    .contentMargins(.horizontal, 16)
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                }
                List {
                    ForEach(filteredItems) { item in
                        let selected = localSelectedItems.contains(item)
                        Button {
                            withAnimation {
                                if selected {
                                    localSelectedItems.remove(item)
                                } else {
                                    localSelectedItems.insert(item)
                                }
                            }
                        } label: {
                            HStack {
                                ItemRowView(item: item)
                                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selected ? .accent : .secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .contentMargins(.top, 0)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        selectedItems = localSelectedItems
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search items")
        .onAppear {
            localSelectedItems = selectedItems
        }
    }
}

struct TagFilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTags: Set<Tag>
    let tags: [Tag]
    
    @State private var localSelectedTags = Set<Tag>()
    @State private var searchText: String = ""
    
    var sortedTags: [Tag] {
        tags.sorted {
            $0.name.localizedLowercase < $1.name.localizedLowercase
        }
    }
    
    var filteredTags: [Tag] {
        if !searchText.isEmpty {
            return sortedTags.filter {
                $0.name.localizedStandardContains(searchText)
            }
        }
        return sortedTags
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if !localSelectedTags.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(localSelectedTags)) { tag in
                                Button {
                                    withAnimation {
                                        if localSelectedTags.contains(tag) {
                                            localSelectedTags.remove(tag)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(tag.name)
                                            .font(.footnote)
                                        Image(systemName: "xmark")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.editorInput)
                            }
                        }
                    }
                    .contentMargins(.horizontal, 16)
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                List {
                    ForEach(filteredTags) { tag in
                        let selected = localSelectedTags.contains(tag)
                        Button {
                            withAnimation {
                                if selected {
                                    localSelectedTags.remove(tag)
                                } else {
                                    localSelectedTags.insert(tag)
                                }
                            }
                        } label: {
                            HStack {
                                Text(tag.name)
                                Spacer()
                                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selected ? .accent : .secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .contentMargins(.top, 0)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        selectedTags = localSelectedTags
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search tags")
        .onAppear {
            localSelectedTags = selectedTags
        }
    }
}

#Preview {
    @Previewable @State var selectedSession: Session?
    
    VStack { }
    .sheet(isPresented: .constant(true)) {
        SearchView(selectedSession: $selectedSession)
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
