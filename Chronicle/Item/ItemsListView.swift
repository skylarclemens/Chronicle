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
        List {
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
    
    init(filter: ItemFilter, sort: SortDescriptor<Item>, searchText: String) {
        _items = Query(filter: Item.predicate(filter: filter, searchText: searchText), sort: [sort])
    }
}

#Preview {
    NavigationStack {
        ItemsListView(filter: .all, sort: SortDescriptor(\Item.name), searchText: "")
    }
    .modelContainer(SampleData.shared.container)
}
