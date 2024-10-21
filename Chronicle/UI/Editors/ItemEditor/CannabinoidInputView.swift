//
//  CannabinoidInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/12/24.
//

import SwiftUI

struct CannabinoidInputView: View {
    @Binding var compounds: [Compound]
    @State private var openPicker: Bool = false
    
    var body: some View {
        DetailSection(header: "Cannabinoids", isScrollView: true) {
            if !compounds.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(compounds, id: \.self) { compound in
                            HStack(spacing: 12) {
                                Text(compound.name)
                                    .bold()
                                Text(compound.value, format: .percent)
                                    .foregroundStyle(.secondary)
                            }
                            .pillStyle()
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
            CannabinoidAddView(compounds: $compounds)
                .interactiveDismissDisabled()
                .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct CannabinoidAddView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var compounds: [Compound]
    
    @State var addedCannabinoids = Set<Compound>()
    
    @State var newCannabinoidName: String = ""
    @State var newCannabinoidValue: Double = 0.0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("THC, CBD, etc.", text: $newCannabinoidName)
                                .textFieldStyle(.roundedBorder)
                            TextField("Percentage", value: $newCannabinoidValue, format: .percent)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(maxWidth: 68)
                            Button("Add", systemImage: "plus.circle.fill") {
                                withAnimation {
                                    add()
                                }
                            }
                            .labelStyle(.iconOnly)
                            .disabled(newCannabinoidName.isEmpty)
                        }
                        .padding()
                    }
                    .background(.ultraThickMaterial,
                                in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    List {
                        ForEach(addedCannabinoids.sorted(by: { $0.name < $1.name }), id: \.id) { cannabinoid in
                            HStack {
                                HStack {
                                    Text(cannabinoid.name)
                                    Text(cannabinoid.value, format: .percent)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(.ultraThickMaterial,
                                                    in: RoundedRectangle(cornerRadius: 12))
                                }
                                Spacer()
                                Button("Delete", systemImage: "xmark.circle.fill") {
                                    withAnimation {
                                        remove(cannabinoid: cannabinoid)
                                    }
                                }
                                .labelStyle(.iconOnly)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Cannabinoids")
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
                            setCannabinoids()
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
            addedCannabinoids = Set(compounds)
        }
    }
    
    private func setCannabinoids() {
        compounds = Array(addedCannabinoids)
    }
    
    private func add() {
        let newCannabinoid = Compound(name: newCannabinoidName, value: newCannabinoidValue, type: .cannabinoid)
        addedCannabinoids.insert(newCannabinoid)
        newCannabinoidName = ""
        newCannabinoidValue = 0.0
    }
    
    private func remove(cannabinoid: Compound) {
        addedCannabinoids.remove(cannabinoid)
    }
}

#Preview {
    @Previewable @State var compounds: [Compound] = []
    
    return VStack {
        CannabinoidInputView(compounds: $compounds)
    }
}
