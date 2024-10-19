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
    
    var body: some View {
        NavigationStack {
            ItemTypeSelectionView(viewModel: $viewModel, parentDismiss: dismiss, item: item)
        }
        .onAppear {
            if let item {
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
            }
        }
    }
}

struct ItemTypeSelectionView: View {
    @Binding var viewModel: ItemEditorViewModel
    let parentDismiss: DismissAction
    let columns: [GridItem] = [GridItem](repeating: GridItem(), count: 3)
    var item: Item?
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(ItemType.allCases, id: \.id) { type in
                    Button {
                        withAnimation {
                            viewModel.itemType = type
                        }
                    } label: {
                        VStack {
                            Image(systemName: type.symbol())
                                .font(.largeTitle)
                                .padding(4)
                                .frame(height: 50)
                            Text(type.label())
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                    .foregroundStyle(.primary)
                    .background(Color(.secondarySystemGroupedBackground).opacity(viewModel.itemType == type ? 0 : 1))
                    .background(.accent.opacity(viewModel.itemType == type ? 0.33 : 0))
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: viewModel.itemType == type ? 1 : 0)
                    )
                }
            }
            .buttonStyle(.borderless)
            .padding()
            Spacer()
        }
        .safeAreaInset(edge: .bottom, alignment: .center) {
            ZStack {
                NavigationLink {
                    ItemEditorBasicsView(viewModel: $viewModel, parentDismiss: parentDismiss, item: item)
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                .saveButton()
                .disabled(viewModel.itemType == nil)
            }
            .frame(height: 120)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(item == nil ? "What are you adding?" : "What type of item?")
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
    }
}

struct ItemEditorBasicsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: ItemEditorViewModel
    let parentDismiss: DismissAction
    var item: Item?
    @FocusState var focusedField: ItemEditorField?
    @State private var showingImagesPicker: Bool = false
    
    @Query(sort: \Strain.name) var strains: [Strain]
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                                        Button("Select photos", systemImage: "photo.badge.plus") {
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
                        ItemPurchaseInputView(viewModel: $viewModel, item: item)
                        ItemEditorCompositionView(viewModel: $viewModel)
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
        .onAppear {
            if item == nil {
                focusedField = .name
                let amountUnit = UnitManager.shared.getAmountUnit(for: viewModel.itemType ?? ItemType.other)
                let dosageUnit = UnitManager.shared.getDosageUnit(for: viewModel.itemType ?? ItemType.other)
                viewModel.amountUnit = amountUnit
                viewModel.dosageUnit = dosageUnit
                
                viewModel.selectedUnits = ItemUnits(amount: amountUnit, dosage: dosageUnit)
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

struct ItemEditorCompositionView: View {
    @Binding var viewModel: ItemEditorViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Composition")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 12) {
                    CannabinoidInputView(compounds: $viewModel.cannabinoids)
                    TerpeneInputView(compounds: $viewModel.terpenes)
                    IngredientsInputView(ingredients: $viewModel.ingredients)
                }
            }
        }
    }
}

struct ItemEditorAdditionalView: View {
    @Binding var viewModel: ItemEditorViewModel
    @State var openTags: Bool = false
    @FocusState.Binding var focusedField: ItemEditorField?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Additional")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                openTags = true
                focusedField = nil
            } label: {
                HStack {
                    Text("Tags")
                        .foregroundStyle(.primary)
                    Spacer()
                    HStack {
                        if !viewModel.tags.isEmpty {
                            Text("\(viewModel.tags.count)") +
                            Text(" selected")
                        }
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $openTags) {
            TagEditorView(tags: $viewModel.tags, context: .item)
                .presentationDragIndicator(.hidden)
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
    @Previewable @Environment(\.dismiss) var dismiss
    @Previewable @State var viewModel = ItemEditorViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        ItemEditorBasicsView(viewModel: $viewModel, parentDismiss: dismiss)
            .modelContainer(SampleData.shared.container)
    }
}

#Preview {
    ItemEditorView(item: SampleData.shared.item)
        .modelContainer(SampleData.shared.container)
}
