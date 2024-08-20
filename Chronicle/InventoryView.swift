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
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(items) { item in

                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .navigationTitle("Inventory")
        }
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addExamples(sampleItems: Item.sampleItems)
    
    return InventoryView()
        .modelContainer(modelPreview.container)
}
