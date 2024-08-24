//
//  ItemEditor.swift
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
                viewModel.dosageAmount = item.dosageAmount
                viewModel.dosageUnit = item.dosageUnit ?? ""
                viewModel.subtype = item.subtype ?? ""
                viewModel.cannabinoids = item.composition
                viewModel.terpenes = item.terpenes
                viewModel.ingredients = item.ingredients
                viewModel.purchasePrice = item.purchasePrice
                viewModel.purchaseLocation = item.purchaseLocation ?? ""
                viewModel.purchaseDate = item.purchaseDate ?? Date()
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
                    SelectedTypeView(selectedType: itemType)
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
                        CannabinoidInputView(cannabinoids: $viewModel.cannabinoids)
                    }
                    Section("Terpenes") {
                        TerpeneInputView(terpenes: $viewModel.terpenes)
                    }
                case .flower:
                    Section("Terpenes") {
                        TerpeneInputView(terpenes: $viewModel.terpenes)
                    }
                case .concentrate:
                    TextField("Concentrate Type", text: $viewModel.subtype)
                case .topical:
                    Section("Terpenes") {
                        TerpeneInputView(terpenes: $viewModel.terpenes)
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
                    SelectedTypeView(selectedType: itemType)
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
                    SelectedTypeView(selectedType: itemType)
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
            item.dosageAmount = viewModel.dosageAmount
            item.dosageUnit = viewModel.dosageUnit
            item.composition = viewModel.cannabinoids
            item.terpenes = viewModel.terpenes
            item.ingredients = viewModel.ingredients
            item.purchasePrice = viewModel.purchasePrice
            item.purchaseLocation = viewModel.purchaseLocation
            item.purchaseDate = viewModel.purchaseDate
            item.imagesData = viewModel.selectedImagesData
            item.strain = viewModel.linkedStrain
        } else {
            let newItem = Item(name: viewModel.name, type: viewModel.itemType ?? .other)
            newItem.brand = viewModel.brand
            newItem.dosageAmount = viewModel.dosageAmount
            newItem.dosageUnit = viewModel.dosageUnit
            newItem.composition = viewModel.cannabinoids
            newItem.terpenes = viewModel.terpenes
            newItem.ingredients = viewModel.ingredients
            newItem.purchasePrice = viewModel.purchasePrice
            newItem.purchaseLocation = viewModel.purchaseLocation
            newItem.purchaseDate = viewModel.purchaseDate
            newItem.imagesData = viewModel.selectedImagesData
            newItem.strain = viewModel.linkedStrain
            
            modelContext.insert(newItem)
        }
    }
}

struct SelectedTypeView: View {
    let selectedType: ItemType
    
    var body: some View {
        Text("New \(selectedType.label().localizedLowercase)")
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
    var cannabinoids: [Cannabinoid] = []
    var terpenes: [Terpene] = []
    var ingredients: [String] = []
    var purchasePrice: Double?
    var purchaseLocation: String = ""
    var purchaseDate: Date = Date()
    var linkedStrain: Strain?
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        
        let item = Item.sampleItem
        container.mainContext.insert(item)
        
        return ItemEditorView(item: item)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
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
