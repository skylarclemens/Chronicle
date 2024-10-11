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
    
    var body: some View {
        if let item,
           let transactions = item.transactions?.sorted(by: { $0.date > $1.date }) {
            List {
                Section {
                    ForEach(transactions) { transaction in
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
                    .onDelete(perform: delete)
                } footer: {
                    HStack(spacing: 0) {
                        Text("Logged amounts that adjust the item's current amount are indicated by ") +
                        Text(Image(systemName: "arrow.triangle.2.circlepath.circle.fill"))
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
    }
    
    func delete(at indexSet: IndexSet) {
        do {
            if let item,
               let transactions = item.transactions {
                for index in indexSet {
                    let transaction = transactions[index]
                    withAnimation {
                        self.item?.transactions?.removeAll(where: { $0 == transaction })
                        modelContext.delete(transaction)
                    }
                }
            }
            try modelContext.save()
        } catch {
            print("Error deleting transactions: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        TransactionHistoryView(item: SampleData.shared.item)
            .modelContainer(SampleData.shared.container)
    }
}
