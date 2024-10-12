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
    
    // Group transactions (with running total) by InventorySnapshot
    var groupedTransactions: [(InventorySnapshot?, [(transaction: InventoryTransaction, total: Double)])] {
        guard let item = item,
              let snapshots = item.snapshots?.sorted(by: { $0.date > $1.date }),
              let transactions = item.transactions
        else { return [] }
        
        var result: [(InventorySnapshot?, [(transaction: InventoryTransaction, total: Double)])] = []
        var remainingTransactions = transactions
        var runningTotal: Double = 0
        
        for snapshot in snapshots {
            runningTotal = 0
            let n = remainingTransactions.partition(by: { $0.date >= snapshot.date })
            let leftoverTransactions = Array(remainingTransactions[..<n])
            let snapshotTransactions = Array(remainingTransactions[n...])
            let snapshotTransactionsWithTotals = snapshotTransactions.sorted(by: { $0.date < $1.date }).map {
                runningTotal += ($0.amount?.value ?? 0)
                return ($0, runningTotal)
            }
            result.append((snapshot, snapshotTransactionsWithTotals))
            remainingTransactions = leftoverTransactions
        }
        
        if !remainingTransactions.isEmpty {
            let remainingTransactionsWithTotals = remainingTransactions.map {
                runningTotal += ($0.amount?.value ?? 0)
                return ($0, runningTotal)
            }
            result.append((nil, remainingTransactionsWithTotals))
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(groupedTransactions, id: \.0?.id) { snapshot, transactions in
                Group {
                    Section {
                        let sortedTransactions = transactions.sorted(by: { $0.transaction.date > $1.transaction.date })
                        ForEach(sortedTransactions, id: \.0) { transaction, total in
                            TransactionRowView(transaction: transaction, total: total)
                        }
                        .onDelete { indexSet in
                            delete(transactions: sortedTransactions.map { $0.transaction }, at: indexSet)
                        }
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
    
    var line: some View {
        VStack { Divider().background(.secondary) }.padding(16)
    }
}

struct TransactionRowView: View {
    var transaction: InventoryTransaction
    var total: Double
    
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
                    if transaction.type == .set && transaction.purchase != nil {
                        Text(TransactionType.purchase.rawValue.localizedCapitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.secondary.opacity(0.1),
                                        in: Capsule())
                    }
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
            VStack(alignment: .trailing, spacing: 4) {
                HStack {
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
                        Group {
                            Text(displayValue, format: .number) +
                            Text(" \(transaction.unit)")
                        }
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                    }
                }
                if transaction.type != .set {
                    Group {
                        Text("Total: ") +
                        Text(total, format: .number) +
                        Text(" \(transaction.unit)")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                }
                    
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
