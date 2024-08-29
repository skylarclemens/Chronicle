//
//  InventoryView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct InventoryView: View {
    @State private var filter: ItemFilter = .all
    @State private var sortOrder = SortDescriptor(\Item.name)
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ItemsListView(filter: filter, sort: sortOrder, searchText: searchText)
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .navigationTitle("Stash")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Menu {
                            Picker("Filter", selection: $filter) {
                                Label("All", systemImage: "rectangle.stack")
                                    .tag(ItemFilter.all)
                                Label("Favorites", systemImage: "star")
                                    .tag(ItemFilter.favorites)
                            }
                            .pickerStyle(.inline)
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.accent, .quaternary)
                        }
                        
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
                                .font(.title3)
                                .foregroundStyle(.accent, .quaternary)
                        }
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

public enum ItemFilter {
    case all, favorites
}

#Preview {
    return InventoryView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
