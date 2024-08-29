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
    }
    
    init(sort: SortDescriptor<Item>, searchString: String) {
        _items = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
}

#Preview {
    NavigationStack {
        ItemsListView(sort: SortDescriptor(\Item.name), searchString: "")
    }
    .modelContainer(SampleData.shared.container)
}
