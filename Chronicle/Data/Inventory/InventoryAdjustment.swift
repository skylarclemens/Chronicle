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
        
        guard newAmount.unit == currentInventory.unit else {
            throw InventoryError.unitMismatch
        }
        
        // Calculate adjustment
        let adjustmentValue: Double = newAmount.value - currentInventory.value
        let adjustment: Amount = Amount(value: adjustmentValue, unit: newAmount.unit)
        
        // Create set transaction with adjusted value
        let transaction: InventoryTransaction = InventoryTransaction(
            type: .set,
            amount: adjustment,
            setAmount: newAmount,
            note: note
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
