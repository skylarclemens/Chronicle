//
//  InventoryView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct InventoryView: View {
    
    @State private var searchText = ""
    @State private var sortOrder = SortDescriptor(\Item.name)
    
    var body: some View {
        NavigationStack {
            ZStack {
                ItemsListView(sort: sortOrder, searchString: searchText)
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .navigationTitle("Stash")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name")
                                .tag(SortDescriptor(\Item.name))
                            Text("Favorites")
                                .tag(SortDescriptor(\Item.favorite, order: .reverse))
                            Text("Date Added")
                                .tag(SortDescriptor(\Item.createdAt))
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .foregroundStyle(.accent, .quaternary)
                    }
                }
            }
        }
    }
}

extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        !lhs && rhs
    }
}

#Preview {
    return InventoryView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
