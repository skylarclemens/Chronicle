//
//  ItemTypeSelectionView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/23/24.
//

import SwiftUI

struct ItemTypeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var viewModel: ItemEditorViewModel
    let parentDismiss: DismissAction

    let columns: [GridItem] = [GridItem](repeating: GridItem(), count: 3)
    var item: Item?
    
    @State private var useDefaultUnits: Bool = true
    @State private var selectedType: ItemType?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(ItemType.allCases, id: \.id) { type in
                            Button {
                                if viewModel.itemType == nil {
                                    withAnimation {
                                        let amountUnit = UnitManager.shared.getAmountUnit(for: type)
                                        let dosageUnit = UnitManager.shared.getDosageUnit(for: type)
                                        
                                        viewModel.amountUnit = amountUnit
                                        viewModel.dosageUnit = dosageUnit
                                        
                                        viewModel.selectedUnits = ItemUnits(amount: amountUnit, dosage: dosageUnit)
                                        
                                        viewModel.itemType = type
                                    }
                                    
                                    dismiss()
                                } else {
                                    selectedType = type
                                }
                            } label: {
                                VStack {
                                    Image(systemName: type.symbol())
                                        .font(.title)
                                        .foregroundStyle(.accent)
                                        .frame(width: 65, height: 65)
                                        .background(.accent.opacity(0.25),
                                                    in: Circle())
                                        .overlay {
                                            if let selectedType,
                                               type == selectedType {
                                                Circle()
                                                    .strokeBorder(.white, lineWidth: 2)
                                            }
                                        }
                                    Text(type.label())
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                }
                            }
                            .frame(minWidth: 0, maxWidth: 100, minHeight: 100, maxHeight: .infinity)
                            .foregroundStyle(.primary)
                            .background {
                                if let selectedType,
                                   type == selectedType {
                                    Color(.secondarySystemGroupedBackground)
                                }
                            }
                            .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding()
                    if viewModel.itemType != nil {
                        VStack(spacing: 12) {
                            Toggle("Use default units", isOn: $useDefaultUnits.animation())
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(.secondarySystemGroupedBackground),
                                            in: .rect(cornerRadius: 12))
                            if useDefaultUnits {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                    Text("If you change the item type, the current units will be reset to the type's default units.")
                                        .font(.footnote)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(viewModel.itemType == nil ? "What are you adding?" : "Select Item Type")
            .navigationBarTitleDisplayMode(viewModel.itemType == nil ? .large : .inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: viewModel.itemType != nil ? .topBarLeading : .topBarTrailing) {
                    Button {
                        if viewModel.itemType != nil {
                            dismiss()
                        } else {
                            parentDismiss()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
                }
                if viewModel.itemType != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            if let type = selectedType {
                                withAnimation {
                                    if useDefaultUnits {
                                        let amountUnit = UnitManager.shared.getAmountUnit(for: type)
                                        let dosageUnit = UnitManager.shared.getDosageUnit(for: type)
                                        
                                        viewModel.amountUnit = amountUnit
                                        viewModel.dosageUnit = dosageUnit
                                        
                                        viewModel.selectedUnits = ItemUnits(amount: amountUnit, dosage: dosageUnit)
                                    }
                                    
                                    viewModel.itemType = type
                                }
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
                if let type = viewModel.itemType {
                    selectedType = type
                }
            }
        }
    }
}

#Preview {
    ItemEditorView()
        .modelContainer(SampleData.shared.container)
}
