//
//  AccessoryListView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI
import SwiftData

struct AccessoryListView: View {
    @Query(sort: \Accessory.name) private var accessories: [Accessory]
    
    var accessoriesByType: [Accessory.AccessoryType: [Accessory]] {
        Dictionary(grouping: accessories, by: \.type)
    }
    
    var body: some View {
        if !accessories.isEmpty {
            ForEach(Accessory.AccessoryType.allCases) { accessoryType in
                if let typeAccessories = accessoriesByType[accessoryType],
                   !typeAccessories.isEmpty {
                    Section(accessoryType.sectionLabel()) {
                        ForEach(typeAccessories) { accessory in
                            NavigationLink {
                                AccessoryDetailsView(accessory: accessory)
                            } label: {
                                AccessoryRowView(accessory: accessory)
                            }
                        }
                    }
                }
            }
            .animation(.default, value: accessories)
        }
    }
    
    init(filter: InventoryFilter, sort: InventorySort, searchText: String) {
        _accessories = Query(filter: Accessory.predicate(filter: filter, searchText: searchText), sort: [sort.accessorySortDescriptors()])
    }
}

#Preview {
    NavigationStack {
        List {
            AccessoryListView(filter: .all, sort: InventorySort.name, searchText: "")
        }
    }
    .modelContainer(SampleData.shared.container)
}
