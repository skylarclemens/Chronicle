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
                viewModel.brand = item.brand ?? ""
                viewModel.dosageAmount = item.dosage?.amount
                viewModel.dosageUnit = item.dosage?.unit ?? ""
                viewModel.subtype = item.subtype ?? ""
                viewModel.compounds = item.compounds
                viewModel.ingredients = item.ingredients
                viewModel.purchasePrice = item.purchaseInfo?.price
                viewModel.purchaseLocation = item.purchaseInfo?.location ?? ""
                viewModel.purchaseDate = item.purchaseInfo?.date ?? Date()
                viewModel.linkedStrain = item.strain
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
                        viewModel.itemType = type
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
                    .background(.ultraThinMaterial)
                    .background(Color.accentColor.opacity(viewModel.itemType == type ? 0.4 : 0))
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: viewModel.itemType == type ? 1 : 0)
                    )
                }
            }
            .buttonStyle(.borderless)
            Spacer()
            NavigationLink {
                ItemEditorBasicsView(viewModel: $viewModel, parentDismiss: parentDismiss, item: item)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .disabled(viewModel.itemType == nil)
        }
        .padding()
        .navigationTitle(item == nil ? "What are you adding?" : "What type of item?")
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ItemEditorBasicsView: View {
    @Binding var viewModel: ItemEditorViewModel
    let parentDismiss: DismissAction
    var item: Item?
    
    var body: some View {
        VStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $viewModel.name)
                }
                Section("Brand") {
                    TextField("Brand", text: $viewModel.brand)
                }
                Section("Photos") {
                    if viewModel.selectedImagesData.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 8) {
                                ForEach(viewModel.selectedImagesData, id: \.self) { imageData in
                                    if let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150, alignment: .leading)
                                            .clipShape(.rect(cornerRadius: 10))
                                            .overlay(alignment: .topTrailing) {
                                                Button {
                                                    viewModel.selectedImagesData.remove(at: viewModel.selectedImagesData.firstIndex(of: imageData)!)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .padding(4)
                                                        .font(.title2)
                                                        .foregroundStyle(.primary, .secondary)
                                                }
                                                .buttonStyle(.plain)
                                                
                                            }
                                    }
                                }
                            }
                            .padding()
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    PhotosPicker(selection: $viewModel.pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.panoramas), .not(.videos)])) {
                        Label("Select photos", systemImage: "photo.badge.plus")
                    }
                    .onChange(of: viewModel.pickerItems) { oldValues, newValues in
                        Task {
                            if viewModel.pickerItems.count == 0 { return }
                            
                            for value in newValues {
                                if let imageData = try? await value.loadTransferable(type: Data.self) {
                                    withAnimation {
                                        viewModel.selectedImagesData.append(imageData)
                                    }
                                }
                            }
                            
                            viewModel.pickerItems.removeAll()
                        }
                    }
                }
            }
            Spacer()
            NavigationLink {
                ItemEditorDetailsView(viewModel: $viewModel, parentDismiss: parentDismiss, item: item)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .padding()
            .disabled(viewModel.name.isEmpty)
        }
        .navigationTitle("Basics")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let itemType = viewModel.itemType {
                    SelectedTypeView(selectedType: itemType, editing: item != nil)
                        .padding(.horizontal, 8)
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ItemEditorDetailsView: View {
    @Binding var viewModel: ItemEditorViewModel
    let parentDismiss: DismissAction
    var item: Item?
    
    var body: some View {
        VStack {
            Form {
                switch viewModel.itemType {
                case .edible, .tincture, .pill, .preroll:
                    Section("Dosage") {
                        HStack {
                            TextField("Amount", value: $viewModel.dosageAmount, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.plain)
                                .padding(.horizontal)
                                .padding(.vertical, 11)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .clipShape(.rect(cornerRadius: 10))
                            TextField("Unit", text: $viewModel.dosageUnit)
                                .textFieldStyle(.plain)
                                .padding(.horizontal)
                                .padding(.vertical, 11)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                    Section("Cannabinoids") {
                        CannabinoidInputView(compounds: $viewModel.compounds)
                    }
                    Section("Terpenes") {
                        TerpeneInputView(compounds: $viewModel.compounds)
                    }
                case .flower:
                    Section("Terpenes") {
                        TerpeneInputView(compounds: $viewModel.compounds)
                    }
                case .concentrate:
                    TextField("Concentrate Type", text: $viewModel.subtype)
                case .topical:
                    Section("Terpenes") {
                        TerpeneInputView(compounds: $viewModel.compounds)
                    }
                case .other:
                    Text("Other options")
                case .none:
                    Text("Other")
                }
            }
            Spacer()
            NavigationLink {
                ItemEditorAdditionalInfoView(viewModel: $viewModel, parentDismiss: parentDismiss, item: item)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .padding()
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let itemType = viewModel.itemType {
                    SelectedTypeView(selectedType: itemType, editing: item != nil)
                        .padding(.horizontal, 8)
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ItemEditorAdditionalInfoView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: ItemEditorViewModel
    let parentDismiss: DismissAction
    @Query(sort: \Strain.name) var strains: [Strain]
    var item: Item?
    
    var body: some View {
        VStack {
            Form {
                Section("Ingredients") {
                    IngredientsInputView(ingredients: $viewModel.ingredients)
                }
                Section("Purchase Information") {
                    TextField("Price", value: $viewModel.purchasePrice, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Location", text: $viewModel.purchaseLocation)
                    DatePicker("Date", selection: $viewModel.purchaseDate)
                }
                if strains.count > 0 {
                    Picker("Strain", systemImage: "leaf", selection: $viewModel.linkedStrain) {
                        Text("None").tag(nil as Strain?)
                        ForEach(strains, id: \.self) { strain in
                            Text(strain.name).tag(strain as Strain?)
                        }
                    }
                }
                
            }
            Spacer()
            Button {
                withAnimation {
                    save()
                    parentDismiss()
                }
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .padding()
        }
        .navigationTitle("Additional Information")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let itemType = viewModel.itemType {
                    SelectedTypeView(selectedType: itemType, editing: item != nil)
                        .padding(.horizontal, 8)
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    parentDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func save() {
        if let item {
            item.name = viewModel.name
            item.type = viewModel.itemType ?? .other
            item.brand = viewModel.brand
            item.dosage = Dosage(amount: viewModel.dosageAmount ?? 0, unit: viewModel.dosageUnit)
            item.compounds = viewModel.compounds
            item.ingredients = viewModel.ingredients
            item.purchaseInfo = PurchaseInfo(price: viewModel.purchasePrice, date: viewModel.purchaseDate, location: viewModel.purchaseLocation)
            item.imagesData = viewModel.selectedImagesData
            item.strain = viewModel.linkedStrain
        } else {
            let newItem = Item(name: viewModel.name, type: viewModel.itemType ?? .other)
            newItem.brand = viewModel.brand
            newItem.dosage = Dosage(amount: viewModel.dosageAmount ?? 0, unit: viewModel.dosageUnit)
            newItem.compounds = viewModel.compounds
            newItem.ingredients = viewModel.ingredients
            newItem.purchaseInfo = PurchaseInfo(price: viewModel.purchasePrice, date: viewModel.purchaseDate, location: viewModel.purchaseLocation)
            newItem.imagesData = viewModel.selectedImagesData
            newItem.strain = viewModel.linkedStrain
            
            modelContext.insert(newItem)
        }
    }
}

struct SelectedTypeView: View {
    let selectedType: ItemType
    let editing: Bool
    
    var body: some View {
        Text("\(editing ? "Editing" : "New") \(selectedType.label().localizedLowercase)")
            .font(.subheadline)
            .foregroundStyle(.accent)
            .buttonStyle(.borderless)
            .controlSize(.small)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(
                Capsule()
                    .stroke(.accent.opacity(0.8), lineWidth: 1)
            )
    }
}

@Observable
class ItemEditorViewModel {
    var item: Item?
    var itemType: ItemType?
    var name: String = ""
    var brand: String = ""
    var dosageAmount: Double?
    var dosageUnit: String = ""
    var subtype: String = ""
    var compounds: [Compound] = []
    var ingredients: [String] = []
    var purchasePrice: Double?
    var purchaseLocation: String = ""
    var purchaseDate: Date = Date()
    var linkedStrain: Strain?
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
}

#Preview {
    ItemEditorView(item: SampleData.shared.item)
        .modelContainer(SampleData.shared.container)
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ItemEditorViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        ItemEditorBasicsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ItemEditorViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        ItemEditorDetailsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ItemEditorViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        ItemEditorAdditionalInfoView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}
