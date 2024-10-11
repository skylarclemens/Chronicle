//
//  InventoryAdjustment.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/11/24.
//

import Foundation
import SwiftData

extension Item {
    func setCurrentAmount(newAmount: Amount, note: String? = nil, context: ModelContext) throws {
        let currentInventory = self.currentInventory ?? Amount(value: 0, unit: self.selectedUnits?.amount ?? .count)
        
        // Create new snapshot
        let snapshot = InventorySnapshot(date: Date(), amount: newAmount)
        if self.snapshots == nil {
            self.snapshots = []
        }
        snapshots?.append(snapshot)
        snapshot.item = self
        
        guard newAmount.unit == currentInventory.unit else {
            throw InventoryError.unitMismatch
        }
        
        // Create set transaction with new inventory value
        let transaction: InventoryTransaction = InventoryTransaction(
            type: .set,
            amount: newAmount,
            note: note,
            updateInventory: false
        )
        
        if self.transactions == nil {
            self.transactions = []
        }
        
        // Add transaction
        self.transactions?.append(transaction)
        transaction.item = self
        
        try context.save()
    }
    
    func addInventoryAdjustment(adjustment: Amount, note: String? = nil, context: ModelContext) throws {
        guard adjustment.unit == self.selectedUnits?.amount else {
            throw InventoryError.unitMismatch
        }
        
        let transaction = InventoryTransaction(
            type: .adjustment,
            amount: adjustment,
            note: note
        )
        
        if self.transactions == nil {
            self.transactions = []
        }
        self.transactions?.append(transaction)
        transaction.item = self
        
        try context.save()
    }
}
