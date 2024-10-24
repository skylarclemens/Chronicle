//
//  ItemEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/9/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ItemEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ItemEditorViewModel()
    var item: Item?
    
    @State private var openItemTypeSelector: Bool = false
    @State private var firstItemTypeSelect: Bool = false
    
    var body: some View {
        NavigationStack {
            ItemEditorBasicsView(viewModel: $viewModel, item: item, parentDismiss: dismiss, openItemTypeSelector: $openItemTypeSelector, firstItemTypeSelect: $firstItemTypeSelect)
        }
        .onAppear {
            if let item {
                openItemTypeSelector = false
                viewModel.itemType = item.type
                viewModel.name = item.name
                viewModel.amountValue = item.amount?.value
                viewModel.amountUnit = item.selectedUnits?.amount ?? .count
                viewModel.dosageValue = item.dosage?.value
                viewModel.dosageUnit = item.selectedUnits?.dosage ?? .count
                viewModel.selectedUnits = item.selectedUnits ?? ItemUnits(amount: .count, dosage: .count)
                viewModel.subtype = item.subtype ?? ""
                viewModel.cannabinoids = item.compounds.filter { $0.type == .cannabinoid }
                viewModel.terpenes = item.compounds.filter { $0.type == .terpene }
                viewModel.ingredients = item.ingredients
                viewModel.transactions = item.transactions ?? []
                viewModel.brand = item.brand ?? ""
                viewModel.linkedStrain = item.strain
                viewModel.tags = item.tags ?? []
                viewModel.selectedImagesData = item.imagesData ?? []
            } else {
                openItemTypeSelector = true
                firstItemTypeSelect = true
            }
        }
    }
}

struct ItemEditorBasicsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: ItemEditorViewModel
    var item: Item?
    let parentDismiss: DismissAction
    @FocusState var focusedField: ItemEditorField?
    @State private var showingImagesPicker: Bool = false
    
    @Binding var openItemTypeSelector: Bool
    @Binding var firstItemTypeSelect: Bool
    
    @State private var openLocationSearch: Bool = false
    
    @Query(sort: \Strain.name) var strains: [Strain]
    
    var body: some View {
        ScrollView {
            VStack {
                EditableHorizontalImagesView(selectedImagesData: $viewModel.selectedImagesData, rotateImages: true)
                    .frame(height: 180)
                VStack(spacing: 24) {
                    Section {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                TextField("Item Name", text: $viewModel.name)
                                    .font(.system(size: 24, weight: .medium, design: .rounded))
                                    .padding(.vertical, 8)
                                    .padding(.trailing)
                                    .focused($focusedField, equals: .name)
                                    .submitLabel(.done)
                                HStack {
                                    Button {
                                        openItemTypeSelector = true
                                    } label: {
                                        HStack(spacing: 4) {
                                            if let type = viewModel.itemType {
                                                Text(type.label())
                                                    .lineLimit(1)
                                            } else {
                                                Text("Type")
                                                    .foregroundStyle(.secondary)
                                            }
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .padding(8)
                                    .padding(.leading, 2)
                                    .background(.accent.opacity(0.33),
                                                in: Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.accent.opacity(0.5))
                                    )
                                    HStack {
                                        Image(systemName: "leaf")
                                        Menu {
                                            Button("None") {
                                                viewModel.linkedStrain = nil
                                            }
                                            ForEach(strains, id: \.self) { strain in
                                                Button {
                                                    viewModel.linkedStrain = strain
                                                } label: {
                                                    Text(strain.name)
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 4) {
                                                if let linkedStrain = viewModel.linkedStrain {
                                                    Text(linkedStrain.name)
                                                        .lineLimit(1)
                                                } else {
                                                    Text("Strain")
                                                        .foregroundStyle(.secondary)
                                                }
                                                Image(systemName: "chevron.up.chevron.down")
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    .tint(.primary)
                                    .padding(8)
                                    .background(.accent.opacity(0.33),
                                                in: Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.accent.opacity(0.5))
                                    )
                                    Button("Photos", systemImage: "photo.badge.plus") {
                                        showingImagesPicker = true
                                    }
                                    .tint(.primary)
                                    .buttonStyle(.editorInput)
                                }
                                .frame(maxWidth: 350, alignment: .leading)
                            }
                        }
                    }
                    ItemEditorDetailsView(viewModel: $viewModel)
                    ItemPurchaseInputView(viewModel: $viewModel, item: item, openLocationSearch: $openLocationSearch)
                    ItemEditorCompositionView(viewModel: $viewModel, itemType: viewModel.itemType)
                    ItemEditorAdditionalView(viewModel: $viewModel, focusedField: $focusedField)
                }
                .padding(.horizontal)
            }
        }
        .safeAreaInset(edge: .bottom, alignment: .center) {
            ZStack {
                Color(UIColor.systemBackground).mask(
                    LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                        .opacity(0.9)
                )
                .allowsHitTesting(false)
                Button {
                    do {
                        try save()
                    } catch {
                        print("New/edited item could not be saved.")
                    }
                    parentDismiss()
                } label: {
                    
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .saveButton()
            }
            .frame(height: 120)
            .ignoresSafeArea(.keyboard)
        }
        .ignoresSafeArea(edges: .bottom)
        .interactiveDismissDisabled()
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("\(item != nil ? "Edit" : "Add") Item")
        .navigationBarTitleDisplayMode(.inline)
        .imagesPicker(isPresented: $showingImagesPicker, pickerItems: $viewModel.pickerItems, imagesData: $viewModel.selectedImagesData)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.close)
            }
        }
        .onChange(of: viewModel.amountUnit) { _, newValue in
            if newValue != viewModel.selectedUnits.amount {
                viewModel.selectedUnits = ItemUnits(amount: viewModel.amountUnit, dosage: viewModel.dosageUnit)
            }
        }
        .onChange(of: viewModel.dosageUnit) { _, newValue in
            if newValue != viewModel.selectedUnits.dosage {
                viewModel.selectedUnits = ItemUnits(amount: viewModel.amountUnit, dosage: viewModel.dosageUnit)
            }
        }
        .sheet(isPresented: $openItemTypeSelector, onDismiss: {
            if firstItemTypeSelect {
                focusedField = .name
                firstItemTypeSelect = false
            }
        }) {
            ItemTypeSelectionView(viewModel: $viewModel, parentDismiss: parentDismiss, item: item)
        }
        .sheet(isPresented: $openLocationSearch) {
            LocationSelectorView(locationInfo: $viewModel.purchaseLocation)
        }
    }
    
    @MainActor
    private func save() throws {
        if let item {
            item.name = viewModel.name
            item.type = viewModel.itemType ?? .other
            item.dosage = Amount(value: viewModel.dosageValue ?? 0, unit: viewModel.dosageUnit)
            item.compounds = viewModel.cannabinoids + viewModel.terpenes
            item.ingredients = viewModel.ingredients
            item.transactions = viewModel.transactions
            item.imagesData = viewModel.selectedImagesData
            item.strain = viewModel.linkedStrain
            item.tags = viewModel.tags
            item.selectedUnits = viewModel.selectedUnits
        } else {
            let newItem = Item(name: viewModel.name, type: viewModel.itemType ?? .other)
            newItem.dosage = Amount(value: viewModel.dosageValue ?? 0, unit: viewModel.dosageUnit)
            newItem.compounds = viewModel.cannabinoids + viewModel.terpenes
            newItem.ingredients = viewModel.ingredients
            newItem.imagesData = viewModel.selectedImagesData
            newItem.strain = viewModel.linkedStrain
            newItem.tags = viewModel.tags
            var newAmount: Amount?
            if let amountValue = viewModel.amountValue {
                newAmount = Amount(value: amountValue, unit: viewModel.amountUnit)
                let initialSnapshot = InventorySnapshot(date: newItem.createdAt, amount: newAmount)
                newItem.snapshots?.append(initialSnapshot)
            }
            let newPurchase = Purchase(date: viewModel.purchaseDate, price: viewModel.purchasePrice, location: viewModel.purchaseLocation)
            let newTransaction = InventoryTransaction(type: viewModel.transactionType, amount: newAmount, updateInventory: false, purchase: newPurchase)
            newItem.selectedUnits = viewModel.selectedUnits
            modelContext.insert(newPurchase)
            modelContext.insert(newTransaction)
            newItem.transactions?.append(newTransaction)
            
            modelContext.insert(newItem)
        }
        try modelContext.save()
    }
}



struct ItemEditorDetailsView: View {
    @Binding var viewModel: ItemEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Details")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    Text("Dosage")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 0) {
                        TextField(viewModel.dosageUnit.promptValue, value: $viewModel.dosageValue, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.plain)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(UIColor.tertiarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 10))
                        Picker("", selection: $viewModel.dosageUnit) {
                            ForEach(AcceptedUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }.accessibilityLabel("Dosage unit picker")
                    }
                }
                Divider()
                HStack {
                    Text("Brand")
                    TextField("Brand", text: $viewModel.brand)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical, 8)
                        .padding(.trailing)
                }
            }
            .padding(.leading)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
        }
    }
}





public enum ItemEditorField {
    case name
}

@Observable
class ItemEditorViewModel {
    var item: Item?
    var itemType: ItemType?
    var name: String = ""
    
    // Values and units
    var amountValue: Double?
    var amountUnit: AcceptedUnit = .count
    var dosageValue: Double?
    var dosageUnit: AcceptedUnit = .count
    var selectedUnits: ItemUnits = ItemUnits(amount: .count, dosage: .count)
    
    var subtype: String = ""
    var brand: String = ""
    
    // Composition
    var cannabinoids: [Compound] = []
    var terpenes: [Compound] = []
    var ingredients: [String] = []
    
    // Transactions
    var transactions: [InventoryTransaction] = []
    var transactionType: TransactionType = .set
    
    // Purchases
    var purchasePrice: Double?
    var purchaseLocation: LocationInfo?
    var purchaseDate: Date = Date()
    
    // Strain
    var linkedStrain: Strain?
    
    // Tags
    var tags: [Tag] = []
    
    // Images
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
}

#Preview {
    ItemEditorView()
        .modelContainer(SampleData.shared.container)
}
