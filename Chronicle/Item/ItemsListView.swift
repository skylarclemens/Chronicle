//
//  ItemsListView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/29/24.
//

import SwiftUI
import SwiftData

struct ItemsListView: View {
    @Query(sort: \Item.name) private var items: [Item]
    
    var itemsByType: [ItemType: [Item]] {
        Dictionary(grouping: items, by: \.type)
    }
    
    var body: some View {
        if !items.isEmpty {
            ForEach(ItemType.allCases, id: \.id) { itemType in
                if let typeItems = itemsByType[itemType],
                   !typeItems.isEmpty {
                    Section(itemType.sectionLabel()) {
                        ForEach(typeItems) { item in
                            NavigationLink {
                                ItemDetailsView(item: item)
                            } label: {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
            }
            .animation(.default, value: items)
        }
    }
    
    init(filter: InventoryFilter, sort: InventorySort, searchText: String) {
        _items = Query(filter: Item.predicate(filter: filter, searchText: searchText), sort: [sort.itemSortDescriptor()])
    }
}

#Preview {
    NavigationStack {
        List {
            ItemsListView(filter: .all, sort: InventorySort.name, searchText: "")
        }
    }
    .modelContainer(SampleData.shared.container)
}
