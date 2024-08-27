//
//  InventoryView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct InventoryView: View {
    @Query(sort: \Item.name) private var items: [Item]
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(searchResults) { item in
                        NavigationLink {
                            ItemDetailsView(item: item)
                        } label: {
                            ItemRowView(item: item)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .navigationTitle("Stash")
        }
    }
    
    var searchResults: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.contains(searchText) }
        }
    }
}

#Preview {
    return InventoryView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
