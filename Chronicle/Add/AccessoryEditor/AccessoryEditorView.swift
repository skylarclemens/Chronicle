//
//  AccessoryEditorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AccessoryEditorView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AccessoryEditorViewModel()
    var accessory: Accessory?
    
    @State private var showingImagesPicker: Bool = false
    @State private var openTypeSelector: Bool = false
    @FocusState var focusedField: AccessoryEditorField?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HorizontalImagesView(selectedImagesData: $viewModel.selectedImagesData, rotateImages: true)
                        .frame(height: 180)
                    VStack(spacing: 24) {
                        VStack(alignment: .leading) {
                            TextField("Accessory Name", text: $viewModel.name)
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                                .padding(.vertical, 8)
                                .padding(.trailing)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.done)
                            HStack {
                                Button {
                                    openTypeSelector = true
                                } label: {
                                    HStack {
                                        Image(systemName: "wrench.and.screwdriver")
                                        HStack(spacing: 4) {
                                            Text(viewModel.type != nil ? viewModel.type?.label().localizedCapitalized ?? "" : "Type")
                                                .foregroundStyle(viewModel.type != nil ? .primary : .secondary)
                                            Image(systemName: "chevron.up.chevron.down")
                                                .font(.caption)
                                        }
                                    }
                                }
                                .tint(.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
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
                        }
                        AccessoryPurchaseEditorView(viewModel: $viewModel)
                    }
                }
                .padding(.horizontal)
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
                            print("New/edited accessory could not be saved.")
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(.accent)
                    .disabled(viewModel.name.isEmpty || viewModel.type == nil)
                    .padding()
                }
                .frame(height: 120)
                .ignoresSafeArea(.keyboard)
                .ignoresSafeArea(edges: .bottom)
            }
            .interactiveDismissDisabled()
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("\(accessory != nil ? "Edit" : "Add") Accessory")
            .navigationBarTitleDisplayMode(.inline)
            .imagesPicker(isPresented: $showingImagesPicker, pickerItems: $viewModel.pickerItems, imagesData: $viewModel.selectedImagesData)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .sheet(isPresented: $openTypeSelector) {
                AccessoryTypeSelectionView(viewModel: $viewModel)
                    .presentationDetents([.medium])
            }
        }
        .onAppear {
            if let accessory {
                viewModel.name = accessory.name
                viewModel.type = accessory.type
                viewModel.purchasePrice = accessory.purchase?.price
                viewModel.purchaseBrand = accessory.brand ?? ""
                viewModel.purchaseLocation = accessory.purchase?.location ?? ""
                viewModel.purchaseDate = accessory.purchase?.date ?? Date()
                viewModel.lastCleanedDate = accessory.lastCleanedDate
                viewModel.favorite = accessory.favorite
                viewModel.sessions = accessory.sessions
                viewModel.selectedImagesData = accessory.imagesData ?? []
            } else {
                focusedField = .name
            }
        }
    }
    
    @MainActor
    private func save() throws {
        let newAccessory = accessory ?? Accessory()
        newAccessory.name = viewModel.name
        newAccessory.type = viewModel.type
        newAccessory.purchase = Purchase(date: viewModel.purchaseDate, price: viewModel.purchasePrice, location: viewModel.purchaseLocation)
        newAccessory.brand = viewModel.purchaseBrand
        newAccessory.lastCleanedDate = viewModel.lastCleanedDate
        newAccessory.favorite = viewModel.favorite
        newAccessory.sessions = viewModel.sessions
        newAccessory.imagesData = viewModel.selectedImagesData
        
        if accessory == nil {
            modelContext.insert(newAccessory)
        }
        
        try modelContext.save()
    }
}

struct AccessoryTypeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: AccessoryEditorViewModel
    let columns: [GridItem] = [GridItem](repeating: GridItem(), count: 3)
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Accessory.AccessoryType.allCases, id: \.id) { type in
                    Button {
                        withAnimation {
                            viewModel.type = type
                        }
                        dismiss()
                    } label: {
                        VStack {
                            Image(systemName: type.symbol())
                                .font(.title)
                                .foregroundStyle(.accent)
                                .frame(width: 65, height: 65)
                                .background(.accent.opacity(0.15),
                                            in: Circle())
                            Text(type.label().localizedCapitalized)
                                .font(.subheadline)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 100, minHeight: 110, maxHeight: .infinity)
                    .foregroundStyle(.primary)
                    .background(.accent.opacity(viewModel.type == type ? 0.1 : 0))
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.bar, lineWidth: viewModel.type == type ? 0.5 : 0)
                    )
                }
            }
            .buttonStyle(.plain)
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
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
    }
}

struct AccessoryPurchaseEditorView: View {
    @Binding var viewModel: AccessoryEditorViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Purchase Information")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading) {
                HStack {
                    Text("Price")
                    TextField("$20.00", value: $viewModel.purchasePrice, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 6)
                .padding(.trailing)
                Divider()
                HStack {
                    Text("Location")
                    TextField("Dispensary", text: $viewModel.purchaseLocation)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 6)
                .padding(.trailing)
                Divider()
                HStack {
                    Text("Brand")
                    TextField("Brand", text: $viewModel.purchaseBrand)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 6)
                .padding(.trailing)
                Divider()
                DatePicker("Date", selection: $viewModel.purchaseDate)
                    .padding(.trailing)
            }
            .padding(.leading)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

public enum AccessoryEditorField {
    case name
}

@Observable
class AccessoryEditorViewModel {
    var name: String = ""
    var type: Accessory.AccessoryType?
    var purchasePrice: Double?
    var purchaseLocation: String = ""
    var purchaseBrand: String = ""
    var purchaseDate: Date = Date()
    var lastCleanedDate: Date?
    var favorite: Bool = false
    var sessions: [Session] = []
    
    var pickerItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
}

#Preview {
    AccessoryEditorView()
        .modelContainer(SampleData.shared.container)
}