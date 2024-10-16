//
//  AccessoriesSelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI
import SwiftData

struct AccessoriesSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var accessories: [Accessory]
    
    @Query(sort: \Accessory.name) var allAccessories: [Accessory]
    
    @State private var selectedAccessories = Set<Accessory>()
    @State private var pickerSearchText: String = ""
    
    var filteredAccessories: [Accessory] {
        if pickerSearchText.isEmpty {
            return allAccessories
        }
        return allAccessories.filter {
            $0.name.localizedCaseInsensitiveContains(pickerSearchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredAccessories, id: \.self) { accessory in
                    let selected = selectedAccessories.contains(accessory)
                    Button {
                        if !selected {
                            selectedAccessories.insert(accessory)
                        } else {
                            selectedAccessories.remove(accessory)
                        }
                    } label: {
                        HStack {
                            Text(accessory.name)
                            Spacer()
                            if selected {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .tag(accessory as Accessory?)
                    .tint(.primary)
                }
            }
            .searchable(text: $pickerSearchText)
            .contentMargins(.bottom, 100)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        withAnimation {
                            accessories = Array(selectedAccessories)
                        }
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
        }
        .onAppear {
            if !accessories.isEmpty {
                selectedAccessories = Set(accessories)
            }
        }
    }
    
}

#Preview {
    @Previewable @State var accessories: [Accessory] = []
    AccessoriesSelectorView(accessories: $accessories)
        .modelContainer(SampleData.shared.container)
}
