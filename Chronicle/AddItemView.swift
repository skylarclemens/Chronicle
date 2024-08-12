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
    @Bindable var item: Item
    @State private var viewModel = AddItemViewModel()
    
    var body: some View {
        NavigationStack {
            /*switch viewModel.currentStep {
            case .itemTypeSelection:
                ItemTypeSelectionView(viewModel: $viewModel)
            case .basics:
                AddItemBasicsView(viewModel: $viewModel)
            case .details:
                details
            case .additionalInfo:
                additionalInfo
            }*/
            ItemTypeSelectionView(viewModel: $viewModel)
                .navigationTitle("What type of item?")
        }
    }
}

struct ItemTypeSelectionView: View {
    let columns: [GridItem] = [GridItem](repeating: GridItem(), count: 3)
    @Binding var viewModel: AddItemViewModel
    
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
                AddItemBasicsView(viewModel: $viewModel)
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
    }
}

struct AddItemBasicsView: View {
    @Binding var viewModel: AddItemViewModel
    
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
                AddItemDetailsView(viewModel: $viewModel)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accentColor)
            .padding()
        }
        .navigationTitle("Basics")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let itemType = viewModel.itemType {
                    SelectedTypeView(selectedType: itemType)
                        .padding(.horizontal, 8)
                }
            }
        }
    }
}

struct AddItemDetailsView: View {
    @Binding var viewModel: AddItemViewModel
    
    var body: some View {
        VStack {
            Form {
                switch viewModel.itemType {
                case .edible, .tincture, .pill:
                    TextField("Dosage Amount", value: $viewModel.dosageAmount, format: .number)
                case .flower:
                    TextField("Terpenes", text: $viewModel.terpenes)
                case .concentrate:
                    TextField("Concentrate Type", text: $viewModel.subtype)
                case .topical:
                    TextField("Terpenes", text: $viewModel.terpenes)
                case .other:
                    Text("Other options")
                case .none:
                    Text("Other")
                }
            }
            Spacer()
            NavigationLink {
                AddItemAdditionalInfoView(viewModel: $viewModel)
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
        }
    }
}

struct AddItemAdditionalInfoView: View {
    @Binding var viewModel: AddItemViewModel
    
    var body: some View {
        VStack {
            Form {
                
            }
            Spacer()
            NavigationLink {
                
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
        }
    }
}

struct SelectedTypeView: View {
    let selectedType: ItemType
    
    var body: some View {
        Button(selectedType.label()) {
            
        }
        .buttonStyle(.bordered)
        .clipShape(Capsule())
        .controlSize(.small)
    }
}

@Observable
class AddItemViewModel {
    var itemType: ItemType?
    var name: String = ""
    var brand: String = ""
    var photos: [UIImage] = []
    var dosageAmount: Double = 0
    var dosageUnit: String = ""
    var subtype: String = ""
    var cannabinoids: [String: Double] = [:]
    var terpenes: String = ""
    var ingredients: [String] = []
    var purchasePrice: String = ""
    var purchaseLocation: String = ""
    var purchaseDate: Date = Date()
    var linkedStrain: Strain?
}

#Preview {
    @State var viewModel = AddItemViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        AddItemBasicsView(viewModel: $viewModel)
    }
}

#Preview {
    @State var viewModel = AddItemViewModel()
    viewModel.itemType = .edible
    return NavigationStack {
        AddItemDetailsView(viewModel: $viewModel)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        
        let example = Item(name: "", type: .other, amount: 0, unit: "")
        return AddItemView(item: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
