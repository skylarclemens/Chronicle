//
//  AccessoryDetailsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct AccessoryDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var accessory: Accessory?
    
    var body: some View {
        if let accessory {
            Text(accessory.name)
        }
    }
}

#Preview {
    AccessoryDetailsView(accessory: SampleData.shared.accessory)
        .modelContext(SampleData.shared.context)
}
