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
    
    var body: some View {
        List {
            ForEach(terpenes, id: \.self) { terpene in
                Text(terpene.name)
            }
            .onDelete(perform: deleteTerpene)
            HStack {
                TextField("Terpene", text: $newTerpene)
                Button {
                    addNewTerpene()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newTerpene.isEmpty)
                .padding(.leading, 16)
            }
        }
    }
    
    private func addNewTerpene() {
        let terpene = Terpene(name: newTerpene)
        terpenes.append(terpene)
        newTerpene = ""
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
