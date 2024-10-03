//
//  ItemInsightsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUI

struct ItemInsightsView: View {
    var item: Item?
    var body: some View {
        if let item {
            
        }
    }
}

#Preview {
    ItemInsightsView(item: SampleData.shared.item)
        .modelContainer(SampleData.shared.container)
}
