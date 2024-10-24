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
    var itemType: ItemType?
    
    var body: some View {
        DetailSection(header: "Cannabinoids", isScrollView: true) {
            if !compounds.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(compounds, id: \.self) { compound in
                            HStack(spacing: 12) {
                                Text(compound.name)
                                    .bold()
                                Group {
                                    Text(compound.value, format: .number) +
                                    Text(compound.unit?.rawValue ?? "")
                                }
                                .foregroundStyle(.secondary)
                            }
                            .pillStyle()
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
            CannabinoidAddView(compounds: $compounds, itemType: itemType)
                .interactiveDismissDisabled()
                .scrollDismissesKeyboard(.immediately)
                .presentationDetents([.height(300)])
        }
    }
}

struct CannabinoidAddView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var compounds: [Compound]
    
    @State var addedCannabinoids = Set<Compound>()
    var itemType: ItemType?
    
    @State private var selectedName: String?
    @State private var newCannabinoidName: String = ""
    @State private var newCannabinoidValue: Double = 0.0
    @State private var unit: CannabinoidMeasurement = .percentage
    
    @State private var commonCannabinoids = ["THC", "CBD", "CBN", "CBG", "CBC", "THCV", "THCA", "CBDA", "CBGa", "Other"]
    
    var validNewCannabinoid: Bool {
        if addedCannabinoids.contains(where: { $0.name == selectedName || $0.name == newCannabinoidName }) {
            return false
        }
        
        if selectedName != nil {
            if selectedName == "Other" && newCannabinoidName.isEmpty {
                return false
            }
            return true
        }
        
        return false
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Cannabinoid")
                        Spacer()
                        Picker("Cannabinoid", selection: $selectedName.animation()) {
                            Text("Select").tag(nil as String?)
                            ForEach(commonCannabinoids, id: \.self) { name in
                                Text(name).tag(name)
                            }
                        }
                    }
                    .padding(.top, 4)
                    Divider()
                    if selectedName == "Other" {
                        HStack {
                            Text("Name")
                            TextField("Name", text: $newCannabinoidName)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.vertical, 8)
                        .padding(.trailing)
                        Divider()
                    }
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("", value: $newCannabinoidValue, format: .number)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 10))
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 68)
                        Picker("Unit", selection: $unit) {
                            ForEach(CannabinoidMeasurement.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                Button {
                    withAnimation {
                        add()
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!validNewCannabinoid)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.accent)
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
            .safeAreaInset(edge: .top) {
                if !addedCannabinoids.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(addedCannabinoids.sorted(by: { $0.name < $1.name }), id: \.id) { cannabinoid in
                                Button {
                                    withAnimation {
                                        remove(cannabinoid: cannabinoid)
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        HStack {
                                            Text(cannabinoid.name)
                                                .bold()
                                            Group {
                                                Text(cannabinoid.value, format: .number) +
                                                Text(cannabinoid.unit?.rawValue ?? "")
                                            }
                                            .foregroundStyle(.secondary)
                                        }
                                        .font(.footnote)
                                        Label("Remove", systemImage: "xmark.circle.fill")
                                            .labelStyle(.iconOnly)
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
                    .contentMargins(.top, 8)
                    .scrollIndicators(.hidden)
                }
            }
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
            if let itemType {
                unit = CannabinoidMeasurement.defaultFor(itemType: itemType)
            }
        }
    }
    
    private func setCannabinoids() {
        compounds = Array(addedCannabinoids)
    }
    
    private func add() {
        var name: String = ""
        if let selectedName {
            if selectedName == "Other" {
                name = newCannabinoidName
            } else {
                name = selectedName
            }
        }
        
        let newCannabinoid = Compound(name: name, value: newCannabinoidValue, unit: unit, type: .cannabinoid)
        addedCannabinoids.insert(newCannabinoid)
        selectedName = nil
        newCannabinoidName = ""
        newCannabinoidValue = 0.0
        var setUnit: CannabinoidMeasurement = .percentage
        if let itemType {
            setUnit = CannabinoidMeasurement.defaultFor(itemType: itemType)
        }
        unit = setUnit
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
