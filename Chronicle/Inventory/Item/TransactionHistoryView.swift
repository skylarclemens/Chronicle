//
//  TransactionHistoryView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/10/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    @Environment(\.modelContext) var modelContext
    var item: Item?
    
    @State private var openAddAdjustment: Bool = false
    
    // Group transactions by InventorySnapshot
    var groupedTransactions: [(InventorySnapshot?, [InventoryTransaction])] {
        guard let item = item,
              let snapshots = item.snapshots?.sorted(by: { $0.date > $1.date }),
              let transactions = item.transactions?.sorted(by: { $0.date > $1.date })
        else { return [] }
        
        var result: [(InventorySnapshot?, [InventoryTransaction])] = []
        var remainingTransactions = transactions
        
        for snapshot in snapshots {
            let n = remainingTransactions.partition(by: { $0.date > snapshot.date })
            let leftoverTransactions = Array(remainingTransactions[..<n])
            let snapshotTransactions = Array(remainingTransactions[n...])
            result.append((snapshot, snapshotTransactions))
            remainingTransactions = leftoverTransactions
        }
        
        if !remainingTransactions.isEmpty {
            result.append((nil, remainingTransactions))
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(groupedTransactions, id: \.0?.id) { snapshot, transactions in
                Section {
                    if let snapshot {
                        HStack {
                            Text("Snapshot")
                                .font(.headline)
                                .fontDesign(.rounded)
                            Spacer()
                            Text(snapshot.date.formatted(.dateTime))
                                .font(.subheadline)
                                .fontDesign(.rounded)
                                .foregroundStyle(.secondary)
                        }
                    }
                    let sortedTransactions = transactions.sorted(by: { $0.date > $1.date })
                    ForEach(sortedTransactions) { transaction in
                        TransactionRowView(transaction: transaction)
                    }
                    .onDelete { indexSet in
                        delete(transactions: sortedTransactions, at: indexSet)
                    }
                }
            }
        }
        .navigationTitle("Amount History")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    EditButton()
                    Button("Add adjustment", systemImage: "plus") {
                        openAddAdjustment = true
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis")
                }
            }
        }
        .sheet(isPresented: $openAddAdjustment) {
            AmountAdjustmentView(item: item)
                .presentationDetents([.medium])
        }
    }
    
    func delete(transactions: [InventoryTransaction], at indexSet: IndexSet) {
        do {
            for index in indexSet {
                let transaction = transactions[index]
                withAnimation {
                    self.item?.transactions?.removeAll(where: { $0 == transaction })
                    modelContext.delete(transaction)
                }
            }
            try modelContext.save()
        } catch {
            print("Error deleting transactions: \(error)")
        }
    }
}

struct TransactionRowView: View {
    let transaction: InventoryTransaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(transaction.type.rawValue.localizedCapitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.secondary.opacity(0.1),
                                    in: Capsule())
                    if transaction.updateInventory {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                Text(transaction.date.formatted(.dateTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if let amount = transaction.amount,
               let displayValue = transaction.displayValue {
                if transaction.updateInventory {
                    if amount.value >= 0 {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.green.opacity(0.75))
                    } else {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red.opacity(0.75))
                    }
                }
                Text(displayValue, format: .number) +
                Text(" \(transaction.unit)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        TransactionHistoryView(item: SampleData.shared.item)
            .modelContainer(SampleData.shared.container)
    }
}
