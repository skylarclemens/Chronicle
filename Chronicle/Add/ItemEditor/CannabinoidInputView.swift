//
//  CannabinoidInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct CannabinoidInputView: View {
    @Binding var compounds: [Compound]
    @State private var newCannabinoidName: String = ""
    @State private var newCannabinoidValue: Double = 0.0
    
    var body: some View {
        List {
            ForEach(compounds, id: \.self) { compound in
                if compound.type == .cannabinoid {
                    HStack {
                        Text(compound.name)
                        Text(compound.value, format: .percent)
                    }
                }
            }
            .onDelete(perform: deleteCannabinoid)
            
            HStack {
                TextField("THC, CBD, etc.", text: $newCannabinoidName)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    TextField("Percentage", value: $newCannabinoidValue, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: 68)
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
        let newCannabinoid = Compound(name: newCannabinoidName, value: newCannabinoidValue, type: .cannabinoid)
        compounds.append(newCannabinoid)
        newCannabinoidName = ""
        newCannabinoidValue = 0.0
    }
    
    private func deleteCannabinoid(at offsets: IndexSet) {
        compounds.remove(atOffsets: offsets)
    }
}

#Preview {
    @State var compounds: [Compound] = []
    return Form {
        CannabinoidInputView(compounds: $compounds)
    }
}
