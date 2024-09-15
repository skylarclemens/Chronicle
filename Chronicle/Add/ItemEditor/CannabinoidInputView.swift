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
        InputSectionView(isScrollView: true) {
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
                    }
                }
                .contentMargins(.horizontal, 16)
                .scrollIndicators(.hidden)
                .padding(.vertical)
            } else {
                Button {
                    openPicker = true
                } label: {
                    HStack {
                        Text("Add")
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tint(.primary)
                .padding(.vertical)
                .padding(.horizontal)
            }
        } header: {
            HStack {
                Text("Cannabinoids")
                    .foregroundStyle(.secondary)
                Spacer()
                if !compounds.isEmpty {
                    Button {
                        openPicker = true
                    } label: {
                        Text("Edit")
                            .font(.subheadline)
                    }
                    .tint(.primary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(.regularMaterial,
                                in: Capsule())
                    .overlay(
                        Capsule()
                            .strokeBorder(.quaternary)
                    )
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
                ZStack {
                    Color(UIColor.systemBackground).mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                    )
                    .allowsHitTesting(false)
                    VStack {
                        Button {
                            withAnimation {
                                setCannabinoids()
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
                        .ignoresSafeArea(.keyboard)
                    }
                    .padding(.vertical, 20)
                }
                .frame(height: 120)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Add Cannabinoids")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
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
