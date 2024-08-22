//
//  TerpeneInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct TerpeneInputView: View {
    @Binding var terpenes: [Terpene]
    @State private var newTerpene: String = ""
    @State private var selectedTerpene: Terpene?
    
    var body: some View {
        Group {
            List {
                ForEach(terpenes, id: \.self) { terpene in
                    Text(terpene.name)
                }
                .onDelete(perform: deleteTerpene)
            }
            Picker("Terpene", selection: $selectedTerpene) {
                Text("None").tag(nil as Terpene?)
                ForEach(Terpene.predefinedTerpenes, id: \.self) { terpene in
                    Text(terpene.name)
                        .tag(terpene as Terpene?)
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
            terpenes.append(selectedTerpene)
        }
        selectedTerpene = nil
    }
    
    private func deleteTerpene(at offsets: IndexSet) {
        terpenes.remove(atOffsets: offsets)
    }
}

#Preview {
    @State var terpenes: [Terpene] = []
    return Form {
        TerpeneInputView(terpenes: $terpenes)
    }
}
