//
//  TerpeneInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct TerpeneInputView: View {
    @Binding var compounds: [Compound]
    @State private var newTerpene: String = ""
    @State private var selectedTerpene: Compound?
    
    var body: some View {
        Group {
            List {
                ForEach(compounds, id: \.self) { compound in
                    if compound.type == .terpene {
                        Text(compound.name)
                    }
                }
                .onDelete(perform: deleteTerpene)
            }
            Picker("Terpene", selection: $selectedTerpene) {
                Text("None").tag(nil as Compound?)
                ForEach(Compound.predefinedTerpenes, id: \.self) { terpene in
                    Text(terpene.name)
                        .tag(terpene as Compound?)
                }
            }.pickerStyle(.navigationLink)
            Button("Add Terpene") {
                addNewTerpene()
            }
            .disabled(selectedTerpene == nil)
        }
    }
    
    private func addNewTerpene() {
        if let selectedTerpene {
            compounds.append(selectedTerpene)
        }
        selectedTerpene = nil
    }
    
    private func deleteTerpene(at offsets: IndexSet) {
        compounds.remove(atOffsets: offsets)
    }
}

#Preview {
    @State var compounds: [Compound] = []
    return Form {
        TerpeneInputView(compounds: $compounds)
    }
}
