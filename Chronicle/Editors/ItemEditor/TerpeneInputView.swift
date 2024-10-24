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
        DetailSection(header: "Terpenes", isScrollView: true) {
            if !compounds.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(compounds, id: \.self) { compound in
                            TerpeneView(compound)
                        }
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
            }
        } headerRight: {
            Button("Add", systemImage: "plus.circle.fill") {
                openPicker = true
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.accent)
            .padding(.trailing)
        }
        .sheet(isPresented: $openPicker) {
            TerpeneSelectorView(compounds: $compounds)
                .interactiveDismissDisabled()
                .scrollDismissesKeyboard(.immediately)
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
                        withAnimation {
                            if !selected {
                                selectedTerpenes.insert(terpene)
                            } else {
                                selectedTerpenes.remove(terpene)
                            }
                        }
                    } label: {
                        HStack {
                            Text(terpene.name)
                            Spacer()
                            Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selected ? .accent : .secondary)
                        }
                    }
                    .tag(terpene as Compound?)
                    .tint(.primary)
                }
            }
            .searchable(text: $pickerSearchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search terpenes")
            .contentMargins(.top, 0)
            .safeAreaInset(edge: .top) {
                if !selectedTerpenes.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(selectedTerpenes).sorted(by: { $0.name < $1.name })) { terpene in
                                Button {
                                    withAnimation {
                                        if selectedTerpenes.contains(terpene) {
                                            selectedTerpenes.remove(terpene)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(terpene.name)
                                            .font(.footnote)
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.editorInput)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .contentMargins(.horizontal, 16)
                    .contentMargins(.vertical, 8)
                    .scrollIndicators(.hidden)
                    .frame(maxHeight: 60, alignment: .top)
                    .background(
                        Color(.systemGroupedBackground)
                            .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                    )
                }
            }
            .navigationTitle("Select Terpenes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        withAnimation {
                            setTerpenes()
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
            selectedTerpenes = Set(compounds)
        }
    }
    
    private func setTerpenes() {
        compounds = Array(selectedTerpenes)
    }
}

#Preview {
    @Previewable @State var compounds: [Compound] = [Compound.predefinedTerpenes[0]]
    TerpeneInputView(compounds: $compounds)
}
