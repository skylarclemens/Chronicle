//
//  CannabinoidInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct CannabinoidInputView: View {
    @Binding var cannabinoids: [Cannabinoid]
    @State private var newCannabinoidName: String = ""
    @State private var newCannabinoidValue: Double = 0.0
    
    var body: some View {
        List {
            ForEach(cannabinoids, id: \.self) { cannabinoid in
                HStack {
                    Text(cannabinoid.name)
                    Text(cannabinoid.value, format: .percent)
                }
            }
            .onDelete(perform: deleteCannabinoid)
            
            HStack {
                TextField("THC, CBD, etc.", text: $newCannabinoidName)
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
        let newCannabinoid = Cannabinoid(name: newCannabinoidName, value: newCannabinoidValue)
        cannabinoids.append(newCannabinoid)
        newCannabinoidName = ""
        newCannabinoidValue = 0.0
    }
    
    private func deleteCannabinoid(at offsets: IndexSet) {
        cannabinoids.remove(atOffsets: offsets)
    }
}

#Preview {
    @State var cannabinoids: [Cannabinoid] = []
    return Form {
        CannabinoidInputView(cannabinoids: $cannabinoids)
    }
}
