//
//  PurchaseInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/15/24.
//

import SwiftUI
import SwiftData

struct PurchaseInputView: View {
    @Binding var viewModel: ItemEditorViewModel
    var item: Item?
    
    @State private var openPurchaseEditor: Bool = false
    @State private var selectedPurchase: Purchase?
    @State private var isDeleting: Bool = false
    
    var body: some View {
        Section {
            if item != nil {
                VStack(alignment: .leading) {
                    Text("Purchases")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        if !viewModel.purchases.isEmpty {
                            VStack(spacing: 16) {
                                ForEach(viewModel.purchases) { purchase in
                                    PurchaseRowView(purchase: purchase)
                                        .overlay(alignment: .topTrailing) {
                                            Menu("Options", systemImage: "ellipsis") {
                                                Section {
                                                    Button {
                                                        selectedPurchase = purchase
                                                        openPurchaseEditor = true
                                                    } label: {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                    Button(role: .destructive) {
                                                        selectedPurchase = purchase
                                                        isDeleting = true
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                            }
                                            .font(.title3)
                                            .labelStyle(.iconOnly)
                                            .tint(.secondary)
                                            .padding(20)
                                        }
                                }
                                Button {
                                    selectedPurchase = nil
                                    openPurchaseEditor = true
                                } label: {
                                    HStack {
                                        Text("Add new purchase")
                                        Spacer()
                                        Image(systemName: "plus.circle.fill")
                                    }
                                }
                                .tint(.accent)
                                .padding()
                                .background(.accent.opacity(0.15),
                                            in: RoundedRectangle(cornerRadius: 12))
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Purchases", systemImage: "cart")
                            } description: {
                                Text("You currently have no logged purchases.")
                            } actions: {
                                Button {
                                    openPurchaseEditor = true
                                } label: {
                                    Label("Add Purchase", systemImage: "plus")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 12))
                }
            } else {
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
                            TextField("Brand", text: $viewModel.brand)
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
        .sheet(isPresented: $openPurchaseEditor) {
            PurchaseEditorView(itemViewModel: $viewModel, purchase: selectedPurchase)
                .presentationDetents([.height(500)])
        }
        .alert("Are you sure you want to delete purchase from \(selectedPurchase?.date ?? Date())?", isPresented: $isDeleting) {
            Button("Yes", role: .destructive) {
                do {
                    try delete(selectedPurchase)
                } catch {
                    print("Could not save session deletion.")
                }
            }
        }
        .onAppear {
            if let item {
                viewModel.purchases = item.purchases
            }
        }
    }
    
    private func delete(_ purchase: Purchase?) throws {
        withAnimation {
            if let purchase {
                viewModel.purchases.removeAll { $0 == purchase }
            }
            self.selectedPurchase = nil
        }
    }
}

struct PurchaseEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = PurchaseEditorViewModel()
    @Binding var itemViewModel: ItemEditorViewModel
    var purchase: Purchase?
    
    var body: some View {
        NavigationStack {
            Section {
                HStack {
                    TextField("2.5", value: $viewModel.amount, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .padding(.horizontal)
                        .padding(.vertical, 11)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 10))
                    TextField("g", text: $viewModel.unit)
                        .textFieldStyle(.plain)
                        .padding(.horizontal)
                        .padding(.vertical, 11)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 10))
                }
            } header: {
                Text("Amount")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            Form {
                Section {
                    HStack {
                        Text("Price")
                        TextField("$20.00", value: $viewModel.price, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Location")
                        TextField("Dispensary", text: $viewModel.location)
                            .multilineTextAlignment(.trailing)
                    }
                    DatePicker("Date", selection: $viewModel.date)
                }
            }
            .scrollDisabled(true)
            .safeAreaInset(edge: .bottom, alignment: .center) {
                ZStack {
                    Color(UIColor.systemBackground).mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .bottom, endPoint: .top)
                    )
                    .allowsHitTesting(false)
                    VStack {
                        Button {
                            save()
                            dismiss()
                        } label: {
                            Text("\(purchase != nil ? "Save" : "Add")")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .tint(.accent)
                        .padding()
                    }
                }
                .frame(height: 120)
            }
            .navigationTitle("\(purchase != nil ? "Edit" : "New") Purchase")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
        .onAppear {
            if let purchase {
                viewModel.date = purchase.date
                viewModel.amount = purchase.amount?.value
                viewModel.unit = purchase.amount?.unit ?? ""
                viewModel.price = purchase.price
                viewModel.location = purchase.location ?? ""
            }
        }
    }
    
    private func save() {
        if purchase == nil {
            var newAmount: Amount?
            if let amount = viewModel.amount {
                newAmount = Amount(value: amount, unit: viewModel.unit)
            }
                
            let newPurchase = Purchase(date: viewModel.date, amount: newAmount, price: viewModel.price, location: viewModel.location)
            itemViewModel.purchases.append(newPurchase)
        }
    }
}

@Observable
class PurchaseEditorViewModel {
    var date: Date = Date()
    var amount: Double?
    var unit: String = ""
    var price: Double?
    var location: String = ""
}

#Preview {
    @Previewable @State var viewModel = ItemEditorViewModel()
    
    PurchaseInputView(viewModel: $viewModel, item: SampleData.shared.item)
        .modelContainer(SampleData.shared.container)
}
