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
                    .background(Color.green.opacity(viewModel.itemType == type ? 0.2 : 0))
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
            .tint(.green)
            .disabled(viewModel.itemType == nil)
        }
        .padding()
    }
}

struct AddItemBasicsView: View {
    @Binding var viewModel: AddItemViewModel
    
    var body: some View {
        VStack {
            if let itemType = viewModel.itemType {
                SelectedTypeView(selectedType: itemType)
            }
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
            .tint(.green)
            .padding()
        }
        .navigationTitle("Basics")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

struct AddItemDetailsView: View {
    @Binding var viewModel: AddItemViewModel
    
    var body: some View {
        VStack {
            if let itemType = viewModel.itemType {
                SelectedTypeView(selectedType: itemType)
            }
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
                AddItemAdditionalInfoView(viewModel: $viewModel)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.green)
            .padding()
        }
        .navigationTitle("Details")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

struct AddItemAdditionalInfoView: View {
    @Binding var viewModel: AddItemViewModel
    
    var body: some View {
        VStack {
            if let itemType = viewModel.itemType {
                SelectedTypeView(selectedType: itemType)
            }
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
            .tint(.green)
            .padding()
        }
        .navigationTitle("Additional Information")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectedTypeView: View {
    let selectedType: ItemType
    
    var body: some View {
        HStack {
            Image(systemName: selectedType.symbol())
            Text(selectedType.label())
            Spacer()
            Button("Edit") {
                
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
            .controlSize(.small)
            .tint(.green)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: .rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1)
                .opacity(0.2)
        )
        .padding(.horizontal)
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
    var cannabinoids: [String: Double] = [:]
    var terpenes: String = ""
    var ingredients: [String] = []
    var purchasePrice: String = ""
    var purchaseLocation: String = ""
    var purchaseDate: Date = Date()
    var linkedStrain: Strain?
}

// Enum to track steps
enum AddItemStep {
    case itemTypeSelection
    case basics
    case details
    case additionalInfo
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

#Preview {
    SelectedTypeView(selectedType: .edible)
}
