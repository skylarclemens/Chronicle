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
                                            .foregroundStyle(.green.opacity(0.5))
                                    } else {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(.red.opacity(0.5))
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

struct AmountAdjustmentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var item: Item?
    
    @State private var adjustmentAction: AdjustmentAction = .adjust
    @State private var adjustmentType: AdjustmentType = .add
    
    @State private var value: Double?
    
    @State private var adjustmentErrorMessage: String?
    @State private var setAmountErrorMessage: String?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Transaction Adjustment Type", selection: $adjustmentAction) {
                    ForEach(AdjustmentAction.allCases, id: \.rawValue) { type in
                        Text(type.label).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                Form {
                    if adjustmentAction == .adjust {
                        Section {
                            HStack {
                                Text("Type")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Add or Subtract", selection: $adjustmentType) {
                                    ForEach(AdjustmentType.allCases, id: \.rawValue) { type in
                                        Image(systemName: type.systemImage).tag(type)
                                    }
                                }
                            }
                            .pickerStyle(.segmented)
                            HStack {
                                TextField("Amount", value: $value, format: .number)
                                    .keyboardType(.decimalPad)
                                Text(item?.selectedUnits?.amount.rawValue ?? "")
                            }
                        } footer: {
                            Text("Item's current amount will be \(adjustmentType == .add ? "increased" : "decreased") by the inputted value.")
                        }
                        if let adjustmentErrorMessage {
                            Section {
                                Text(adjustmentErrorMessage)
                                    .foregroundStyle(.red)
                            }
                            .listRowBackground(Color.red.opacity(0.15))
                        }
                    } else {
                        Section {
                            HStack {
                                TextField("Current amount", value: $value, format: .number)
                                    .keyboardType(.decimalPad)
                                Text(item?.selectedUnits?.amount.rawValue ?? "")
                            }
                        } footer: {
                            Text("Item's current amount will be set to the inputted value.")
                        }
                        if let setAmountErrorMessage {
                            Section {
                                Text(setAmountErrorMessage)
                                    .foregroundStyle(.red)
                            }
                            .listRowBackground(Color.red.opacity(0.15))
                        }
                    }
                    
                    if let errorMessage {
                        Section {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
                        .listRowBackground(Color.red.opacity(0.15))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(adjustmentAction == .adjust ? "Add" : "Save") {
                        save()
                    }
                }
            }
        }
    }
    
    @MainActor
    func save() {
        guard let item else { return }
        guard let value = self.value else {
            switch adjustmentAction {
            case .adjust:
                adjustmentErrorMessage = "Please provide an adjustment amount."
            case .set:
                setAmountErrorMessage = "Please provide an amount."
            }
            return
        }
        guard let unit = item.selectedUnits?.amount else { return }
        
        do {
            switch adjustmentAction {
            case .adjust:
                guard value > 0 else {
                    adjustmentErrorMessage = "Adjustment amount cannot be zero or negative. Set type to - if you'd like to make a negative adjustment."
                    return
                }
                var newAmount: Amount
                if adjustmentType == .subtract {
                    newAmount = Amount(value: -value, unit: unit)
                } else {
                    newAmount = Amount(value: value, unit: unit)
                }
                try item.addInventoryAdjustment(adjustment: newAmount, context: modelContext)
            case .set:
                let newAmount = Amount(value: value, unit: unit)
                try item.setCurrentAmount(newAmount: newAmount, context: modelContext)
            }
            adjustmentErrorMessage = nil
            setAmountErrorMessage = nil
            errorMessage = nil
            dismiss()
        } catch {
            switch adjustmentAction {
            case .adjust:
                adjustmentErrorMessage = "Failed to apply adjustment: \(error.localizedDescription)"
            case .set:
                setAmountErrorMessage = "Failed to set current amount: \(error.localizedDescription)"
            }
            
        }
    }
    
    enum AdjustmentType: String, CaseIterable {
        case add
        case subtract
        
        var systemImage: String {
            switch self {
            case .add:
                "plus"
            case .subtract:
                "minus"
            }
        }
    }
    
    enum AdjustmentAction: String, CaseIterable {
        case adjust
        case set
        
        var label: String {
            switch self {
            case .adjust:
                "Adjustment"
            case .set:
                "Set amount"
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

//#Preview {
//    NavigationStack {
//        VStack {
//            
//        }
//        .sheet(isPresented: .constant(true)) {
//            AmountAdjustmentView(item: SampleData.shared.item)
//        }
//    }
//    .modelContainer(SampleData.shared.container)
//}
