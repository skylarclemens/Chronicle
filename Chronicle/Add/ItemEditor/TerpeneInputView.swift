//
//  TerpeneInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct TerpeneInputView: View {
    @Binding var compounds: [Compound]
    @State private var openPicker: Bool = false
    
    var body: some View {
        Group {
            HStack {
                if !compounds.isEmpty {
                    ForEach(compounds, id: \.self) { compound in
                        Text(compound.name)
                            .pillStyle(compound.color.color)
                    }
                } else {
                    Button {
                        openPicker = true
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .tint(.secondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(.regularMaterial,
                                in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .sheet(isPresented: $openPicker) {
            TerpeneSelectorView(compounds: $compounds)
        }
    }
}

struct TerpeneSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var compounds: [Compound]
    @State private var selectedTerpenes = Set<Compound>()
    
    @State private var pickerSearchText: String = ""
    
    var terpenes: [Compound] {
        Compound.predefinedTerpenes.filter {
            pickerSearchText.isEmpty ? true :
            $0.name.localizedCaseInsensitiveContains(pickerSearchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(terpenes, id: \.self) { terpene in
                    let selected = selectedTerpenes.contains(terpene)
                    Button {
                        if !selected {
                            selectedTerpenes.insert(terpene)
                        } else {
                            selectedTerpenes.remove(terpene)
                        }
                    } label: {
                        HStack {
                            Text(terpene.name)
                            Spacer()
                            if selected {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .tag(terpene as Compound?)
                    .tint(.primary)
                }
            }
            .searchable(text: $pickerSearchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        setTerpenes()
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            selectedTerpenes = Set(compounds)
        }
    }
    
    private func setTerpenes() {
        if !selectedTerpenes.isEmpty {
            compounds = Array(selectedTerpenes)
        }
    }
}

#Preview {
    @Previewable @State var compounds: [Compound] = [Compound.predefinedTerpenes[0], Compound.predefinedTerpenes[1]]
    return Form {
        TerpeneInputView(compounds: $compounds)
    }
}
