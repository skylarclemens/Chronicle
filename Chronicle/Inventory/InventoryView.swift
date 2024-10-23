//
//  InventoryView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct InventoryView: View {
    @State private var filter: InventoryFilter = .all
    @State private var sortOrder: InventorySort = .name
    @State private var searchText = ""
    @State private var listSelection: InventoryType = .items
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select which list to view", selection: $listSelection.animation()) {
                    Text(InventoryType.items.rawValue.localizedCapitalized)
                        .tag(InventoryType.items)
                    Text(InventoryType.strains.rawValue.localizedCapitalized)
                        .tag(InventoryType.strains)
                    Text(InventoryType.accessories.rawValue.localizedCapitalized)
                        .tag(InventoryType.accessories)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                List {
                    switch listSelection {
                    case .items:
                        ItemsListView(filter: filter, sort: sortOrder, searchText: searchText)
                    case .strains:
                        StrainListView(filter: filter, sort: sortOrder, searchText: searchText)
                    case .accessories:
                        AccessoryListView(filter: filter, sort: sortOrder, searchText: searchText)
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .contentMargins(.bottom, 80)
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
                            Picker("Filter", selection: $filter.animation()) {
                                Label("All", systemImage: "rectangle.stack")
                                    .tag(InventoryFilter.all)
                                Label("Favorites", systemImage: "star")
                                    .tag(InventoryFilter.favorites)
                            }
                            .pickerStyle(.inline)
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.accent, .quaternary)
                        }
                        
                        Menu {
                            Picker("Sort", selection: $sortOrder.animation()) {
                                Text("Name")
                                    .tag(InventorySort.name)
                                Text("Favorites")
                                    .tag(InventorySort.favorites)
                                Text("Date Added")
                                    .tag(InventorySort.dateAdded)
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
            .addContentSheets()
        }
    }
    
    private enum InventoryType: String {
        case items, strains, accessories
    }
}

extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        !lhs && rhs
    }
}

public enum InventorySort {
    case name, favorites, dateAdded
    
    func itemSortDescriptor() -> SortDescriptor<Item> {
        switch self {
        case .name:
            return SortDescriptor(\Item.name)
        case .favorites:
            return SortDescriptor(\Item.favorite, order: .reverse)
        case .dateAdded:
            return SortDescriptor(\Item.createdAt)
        }
    }
    
    func strainSortDescriptor() -> SortDescriptor<Strain> {
        switch self {
        case .name:
            return SortDescriptor(\Strain.name)
        case .favorites:
            return SortDescriptor(\Strain.favorite, order: .reverse)
        case .dateAdded:
            return SortDescriptor(\Strain.createdAt)
        }
    }
    
    func accessorySortDescriptor() -> SortDescriptor<Accessory> {
        switch self {
        case .name:
            return SortDescriptor(\Accessory.name)
        case .favorites:
            return SortDescriptor(\Accessory.favorite, order: .reverse)
        case .dateAdded:
            return SortDescriptor(\Accessory.createdAt)
        }
    }
}

public enum InventoryFilter {
    case all, favorites
}

#Preview {
    return InventoryView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
