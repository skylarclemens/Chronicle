//
//  TagEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/23/24.
//

import SwiftUI
import SwiftData

struct TagEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = TagEditorViewModel()
    @Query(sort: \Tag.name) var allTags: [Tag]
    @Binding var tags: [Tag]
    var context: Tag.TagContext = .all
    var contextString: String {
        switch context {
        case .item:
            return " for items"
        case .session:
            return " for sessions"
        case .all:
            return ""
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.sortedSuggestedTags.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.sortedSuggestedTags) { tag in
                                Button {
                                    withAnimation {
                                        viewModel.toggleTag(tag)
                                    }
                                } label: {
                                    Text(tag.name)
                                }
                                .tagStyle(selected: viewModel.tags.contains(tag))
                            }
                        }
                    }
                    .contentMargins(.all, 16)
                    .background(.regularMaterial,
                                in: RoundedRectangle(cornerRadius: 12))
                } else {
                    Text("No tags exist\(contextString).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(.regularMaterial,
                                    in: RoundedRectangle(cornerRadius: 12))
                }
                HStack {
                    TextField("Add New Tag", text: $viewModel.newTagName)
                        .submitLabel(.done)
                        .onSubmit {
                            withAnimation {
                                viewModel.addNewTag()
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(.regularMaterial,
                                    in: RoundedRectangle(cornerRadius: 12))
                    Button("Add", systemImage: "plus.circle.fill") {
                        withAnimation {
                            viewModel.addNewTag()
                        }
                    }
                    .labelStyle(.iconOnly)
                    .disabled(viewModel.newTagName.isEmpty)
                }
                .padding(.vertical)
                
                Spacer()
            }
            .navigationTitle("Edit Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        tags = Array(viewModel.tags)
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .onAppear {
                viewModel.tags = Set(tags)
                viewModel.allTags = Set(allTags).union(viewModel.tags)
                
                switch context {
                case .item:
                    viewModel.suggestedTags = viewModel.allTags.filter {
                        if $0.hasNoItemsOrSessions {
                            return true
                        } else if !$0.items.isEmpty {
                            return true
                        } else {
                            return false
                        }
                    }
                case .session:
                    viewModel.suggestedTags = viewModel.allTags.filter {
                        if $0.hasNoItemsOrSessions {
                            return true
                        } else if !$0.sessions.isEmpty {
                            return true
                        } else {
                            return false
                        }
                    }
                case .all:
                    viewModel.suggestedTags = viewModel.allTags
                }
            }
        }
    }
}

@Observable
class TagEditorViewModel {
    var suggestedTags = Set<Tag>()
    var tags = Set<Tag>()
    var newTagName: String = ""
    var allTags = Set<Tag>()
    
    var sortedSuggestedTags: [Tag] {
        suggestedTags.sorted { (lhs, rhs) in
            if tags.contains(lhs) == tags.contains(rhs) {
                return lhs.name.lowercased() > rhs.name.lowercased()
            }
            
            return tags.contains(lhs) > tags.contains(rhs)
        }
    }
    
    func toggleTag(_ tag: Tag) {
        if tags.contains(tag) {
            tags.remove(tag)
        } else {
            tags.insert(tag)
        }
    }
    
    func addNewTag() {
        if let existingTag = allTags.first(where: { $0.name.lowercased() == newTagName.lowercased() }) {
            tags.insert(existingTag)
            suggestedTags.insert(existingTag)
            newTagName = ""
        } else if !newTagName.isEmpty {
            let tag = Tag(name: newTagName)
            tags.insert(tag)
            suggestedTags.insert(tag)
            newTagName = ""
        }
    }
}

#Preview {
    @Previewable @State var tags: [Tag] = []
    TagEditorView(tags: $tags, context: .item)
        .modelContainer(SampleData.shared.container)
}
