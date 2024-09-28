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
    
    var body: some View {
        if !items.isEmpty {
            Section("Items") {
                ForEach(items) { item in
                    NavigationLink {
                        ItemDetailsView(item: item)
                    } label: {
                        ItemRowView(item: item)
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
