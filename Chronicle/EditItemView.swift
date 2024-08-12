//
//  AddItemView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/9/24.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var item: Item
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $item.name)
                }
                
                Section("Amount") {
                    HStack {
                        TextField("Amount", value: $item.amount, format: .number)
                            .keyboardType(.numberPad)
                        TextField("Unit", text: $item.unit)
                    }
                }
                
                DatePicker("Purchase date", selection: $item.purchaseDate)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        
        let example = Item(name: "", type: .other, amount: 0, unit: "")
        return AddItemView(item: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
