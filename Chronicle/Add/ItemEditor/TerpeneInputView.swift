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
                        Button {
                            openPicker = true
                        } label: {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        .tint(.accent)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(.accent.opacity(0.15),
                                    in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
            }
        } headerRight: {
            Group {
                if compounds.isEmpty {
                    Button {
                        openPicker = true
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .tint(.accent)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(.accent.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 12))
                    .padding(.trailing)
                }
            }
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
            ZStack(alignment: .bottom) {
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
                .contentMargins(.bottom, 100)
                ZStack {
                    Color(UIColor.systemBackground).mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                    )
                    .allowsHitTesting(false)
                    VStack {
                        Button {
                            withAnimation {
                                setTerpenes()
                            }
                            dismiss()
                        } label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(Color(red: 16 / 255, green: 69 / 255, blue: 29 / 255))
                        .padding()
                    }
                    .padding(.vertical, 20)
                }
                .frame(height: 120)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Select Terpenes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
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
