//
//  AddItemView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/9/24.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddItemViewModel()
    
    var body: some View {
        NavigationStack {
            ItemTypeSelectionView(viewModel: $viewModel, parentDismiss: dismiss)
        }
    }
}

struct ItemTypeSelectionView: View {
    @Binding var viewModel: AddItemViewModel
    let parentDismiss: DismissAction
    let columns: [GridItem] = [GridItem](repeating: GridItem(), count: 3)
    
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
                AddItemBasicsView(viewModel: $viewModel, parentDismiss: parentDismiss)
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
        .navigationTitle("What type of item?")
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

struct AddItemBasicsView: View {
    @Binding var viewModel: AddItemViewModel
    let parentDismiss: DismissAction
    
    var body: some View {
        VStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $viewModel.name)
                }
                Section("Brand") {
                    TextField("Brand", text: $viewModel.brand)
                }
            }
            Spacer()
            NavigationLink {
                AddItemDetailsView(viewModel: $viewModel, parentDismiss: parentDismiss)
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

struct AddItemDetailsView: View {
    @Binding var viewModel: AddItemViewModel
    let parentDismiss: DismissAction
    
    var body: some View {
        VStack {
            Form {
                switch viewModel.itemType {
                case .edible, .tincture, .pill:
                    Section("Dosage") {
                        HStack {
                            TextField("Amount (2.5)", value: $viewModel.dosageAmount, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                            TextField("Unit (mg)", text: $viewModel.dosageUnit)
                                .textFieldStyle(.roundedBorder)
                        }
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
                AddItemAdditionalInfoView(viewModel: $viewModel, parentDismiss: parentDismiss)
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

struct AddItemAdditionalInfoView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: AddItemViewModel
    let parentDismiss: DismissAction
    
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
        let newItem = Item(name: viewModel.name, type: viewModel.itemType ?? .other)
        newItem.brand = viewModel.brand
        newItem.dosageAmount = viewModel.dosageAmount
        newItem.dosageUnit = viewModel.dosageUnit
        newItem.composition = viewModel.cannabinoids
        newItem.ingredients = viewModel.ingredients
        newItem.purchasePrice = viewModel.purchasePrice
        newItem.purchaseLocation = viewModel.purchaseLocation
        newItem.purchaseDate = viewModel.purchaseDate
        
        modelContext.insert(newItem)
    }
}

struct SelectedTypeView: View {
    let selectedType: ItemType
    
    var body: some View {
        Button(selectedType.label()) {
            
        }
        .buttonStyle(.borderless)
        .controlSize(.small)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .overlay(
            Capsule()
                .stroke(.green.opacity(0.8), lineWidth: 1)
        )
    }
}

@Observable
class AddItemViewModel {
    var itemType: ItemType?
    var name: String = ""
    var brand: String = ""
    var photos: [UIImage] = []
    var dosageAmount: Double?
    var dosageUnit: String = ""
    var subtype: String = ""
    var cannabinoids: [String: Double] = [:]
    var terpenes: [String] = []
    var ingredients: [String] = []
    var purchasePrice: Double?
    var purchaseLocation: String = ""
    var purchaseDate: Date = Date()
    var linkedStrain: Strain?
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddItemViewModel()
    
    viewModel.itemType = .edible
    return NavigationStack {
        AddItemAdditionalInfoView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddItemViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        AddItemBasicsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddItemViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        AddItemDetailsView(viewModel: $viewModel, parentDismiss: dismiss)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        
        let example = Item(name: "", type: .other, amount: 0)
        return AddItemView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
