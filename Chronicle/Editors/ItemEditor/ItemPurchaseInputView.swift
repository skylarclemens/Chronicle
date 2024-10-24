//
//  PurchaseInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/15/24.
//

import SwiftUI
import SwiftData

struct ItemPurchaseInputView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var viewModel: ItemEditorViewModel
    var item: Item?
    
    @State private var openPurchaseEditor: Bool = false
    @State private var selectedTransaction: InventoryTransaction?
    @State private var isDeleting: Bool = false
    
    @Binding var openLocationSearch: Bool
    
    var body: some View {
        Section {
            if item != nil {
                VStack(alignment: .leading) {
                    Text("Purchases")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        if !viewModel.transactions.isEmpty {
                            VStack(spacing: 16) {
                                ForEach(viewModel.transactions) { transaction in
                                    if let purchase = transaction.purchase {
                                        PurchaseRowView(purchase: purchase)
                                            .overlay(alignment: .topTrailing) {
                                                Menu {
                                                    Section {
                                                        Button {
                                                            selectedTransaction = transaction
                                                            openPurchaseEditor = true
                                                        } label: {
                                                            Label("Edit", systemImage: "pencil")
                                                        }
                                                        Button(role: .destructive) {
                                                            selectedTransaction = transaction
                                                            isDeleting = true
                                                        } label: {
                                                            Label("Delete", systemImage: "trash")
                                                        }
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis")
                                                        .imageScale(.large)
                                                        .padding(20)
                                                        .tint(.secondary)
                                                        .contentShape(Circle())
                                                }
                                                .accessibilityLabel("Purchase Options Menu")
                                            }
                                    }
                                }
                                Button {
                                    selectedTransaction = nil
                                    openPurchaseEditor = true
                                } label: {
                                    HStack {
                                        Text("Add new purchase")
                                        Spacer()
                                        Image(systemName: "plus.circle.fill")
                                    }
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .tint(.accent)
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
                    PurchaseInputView(amountValue: $viewModel.amountValue, amountUnit: $viewModel.amountUnit, price: $viewModel.purchasePrice, location: $viewModel.purchaseLocation, date: $viewModel.purchaseDate, openLocationSearch: $openLocationSearch)
                }
            }
        }
        .sheet(isPresented: $openPurchaseEditor) {
            PurchaseEditorView(itemViewModel: $viewModel, transaction: $selectedTransaction)
                .presentationDetents([.height(450)])
        }
        
        .alert("Are you sure you want to delete purchase from \(selectedTransaction?.purchase?.date ?? Date())?", isPresented: $isDeleting) {
            Button("Yes", role: .destructive) {
                do {
                    try delete(selectedTransaction)
                } catch {
                    print("Could not save session deletion.")
                }
            }
        }
        .onAppear {
            if let item {
                viewModel.transactions = item.transactions ?? []
            }
        }
    }
    
    private func delete(_ transaction: InventoryTransaction?) throws {
        withAnimation {
            if let transaction {
                viewModel.transactions.removeAll { $0 == transaction }
                modelContext.delete(transaction)
            }
            self.selectedTransaction = nil
        }
    }
}

struct PurchaseEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = PurchaseEditorViewModel()
    @Binding var itemViewModel: ItemEditorViewModel
    @Binding var transaction: InventoryTransaction?
    
    @State private var openLocationSearch: Bool = false
    
    var body: some View {
        NavigationStack {
            PurchaseInputView(amountValue: $viewModel.amount, amountUnit: $viewModel.unit, price: $viewModel.price, location: $viewModel.location, date: $viewModel.date, shouldUpdateInventory: $viewModel.shouldUpdateInventory, openLocationSearch: $openLocationSearch, showUpdateInventoryToggle: transaction?.type != .set ? true : false, transaction: transaction)
            .padding(.horizontal)
            .navigationTitle("\(transaction?.purchase != nil ? "Edit" : "New") Purchase")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        save()
                        dismiss()
                    } label: {
                        Text("\(transaction?.purchase != nil ? "Save" : "Add")")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
        }
        .onAppear {
            if let transaction,
               let purchase = transaction.purchase {
                viewModel.date = purchase.date
                viewModel.amount = transaction.amount?.value ?? 0.0
                viewModel.unit = transaction.amount?.unit ?? .count
                viewModel.price = purchase.price
                viewModel.location = purchase.location
                viewModel.shouldUpdateInventory = transaction.updateInventory
            } else {
                viewModel.unit = itemViewModel.selectedUnits.amount
            }
        }
        .sheet(isPresented: $openLocationSearch) {
            LocationSelectorView(locationInfo: $viewModel.location)
        }
    }
    
    private func save() {
        if let transaction,
           let purchase = transaction.purchase {
            purchase.date = viewModel.date
            purchase.price = viewModel.price
            purchase.location = viewModel.location
            
            if let amountValue = viewModel.amount {
                transaction.amount = Amount(value: amountValue, unit: viewModel.unit)
            }
            transaction.type = .purchase
            transaction.updateInventory = viewModel.shouldUpdateInventory
            
            if itemViewModel.amountUnit != viewModel.unit {
                itemViewModel.amountUnit = viewModel.unit
            }
        } else {
            var newAmount: Amount?
            if let amountValue = viewModel.amount {
                newAmount = Amount(value: amountValue, unit: viewModel.unit)
            }
            
            let newPurchase = Purchase(date: viewModel.date, price: viewModel.price, location: viewModel.location)
            let newTransaction = InventoryTransaction(type: .purchase, amount: newAmount, updateInventory: viewModel.shouldUpdateInventory, purchase: newPurchase)
            
            itemViewModel.amountUnit = viewModel.unit
            itemViewModel.transactions.append(newTransaction)
        }
    }
}

@Observable
class PurchaseEditorViewModel {
    var date: Date = Date()
    var amount: Double?
    var unit: AcceptedUnit = .count
    var price: Double?
    var location: LocationInfo?
    var transaction: InventoryTransaction?
    var shouldUpdateInventory: Bool = true
}

#Preview {
    @Previewable @State var viewModel = ItemEditorViewModel()
    @Previewable @State var openLocationSearch = false
    
    ItemPurchaseInputView(viewModel: $viewModel, openLocationSearch: $openLocationSearch)
        .modelContainer(SampleData.shared.container)
}
