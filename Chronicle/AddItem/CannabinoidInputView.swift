//
//  CannabinoidInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct CannabinoidInputView: View {
    @Binding var cannabinoids: [String: Double]
    @State private var newCannabinoidName: String = ""
    @State private var newCannabinoidValue: Double = 0.0
    
    var body: some View {
        List {
            ForEach(Array(cannabinoids.keys.sorted()), id: \.self) { key in
                HStack {
                    TextField("Cannabinoid", text: Binding(
                        get: { key },
                        set: { newKey in
                            if let value = cannabinoids.removeValue(forKey: key) {
                                cannabinoids[newKey] = value
                            }
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    HStack {
                        TextField("Percentage", value: Binding(
                            get: { cannabinoids[key] ?? 0.0 },
                            set: { newValue in
                                cannabinoids[key] = newValue
                            }
                        ), format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: 68)
                        Text("%")
                    }
                }
            }
            .onDelete(perform: deleteCannabinoid)
            
            HStack {
                TextField("Cannabinoid (THC, CBD, etc.)", text: $newCannabinoidName)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    TextField("Percentage", value: $newCannabinoidValue, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: 68)
                    Text("%")
                }
                Button {
                    addCannabinoid()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newCannabinoidName.isEmpty)
                .padding(.leading, 16)
            }
        }
    }
    
    private func addCannabinoid() {
        cannabinoids[newCannabinoidName] = newCannabinoidValue
        newCannabinoidName = ""
        newCannabinoidValue = 0.0
    }
    
    private func deleteCannabinoid(at offsets: IndexSet) {
        for index in offsets {
            let key = Array(cannabinoids.keys.sorted())[index]
            cannabinoids.removeValue(forKey: key)
        }
    }
}

#Preview {
    @State var cannabinoids: [String: Double] = [:]
    return Form {
        CannabinoidInputView(cannabinoids: $cannabinoids)
    }
}
