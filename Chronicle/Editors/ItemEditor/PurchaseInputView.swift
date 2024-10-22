//
//  PurchaseInputView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/10/24.
//

import SwiftUI

struct PurchaseInputView: View {
    @Binding var amountValue: Double?
    @Binding var amountUnit: AcceptedUnit
    @Binding var price: Double?
    @Binding var location: LocationInfo?
    @Binding var date: Date
    @Binding var shouldUpdateInventory: Bool
    
    @State private var openLocationSearch: Bool = false
    @State private var showingInventoryUpdateConfirmation: Bool = false
    
    var showUpdateInventoryToggle: Bool
    var transaction: InventoryTransaction?
    
    init(amountValue: Binding<Double?>, amountUnit: Binding<AcceptedUnit>, price: Binding<Double?>, location: Binding<LocationInfo?>, date: Binding<Date>, shouldUpdateInventory: Binding<Bool> = Binding.constant(true), showUpdateInventoryToggle: Bool = false, transaction: InventoryTransaction? = nil) {
        self._amountValue = amountValue
        self._amountUnit = amountUnit
        self._price = price
        self._location = location
        self._date = date
        self._shouldUpdateInventory = shouldUpdateInventory
        self.showUpdateInventoryToggle = showUpdateInventoryToggle
        self.transaction = transaction
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Amount")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 0) {
                        TextField(amountUnit.promptValue, value: $amountValue, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.plain)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 10))
                        Picker("", selection: $amountUnit) {
                            ForEach(AcceptedUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                    }
                }
                if showUpdateInventoryToggle {
                    Divider()
                    Toggle("Update Inventory", systemImage: "arrow.triangle.2.circlepath", isOn: $shouldUpdateInventory)
                        .onChange(of: shouldUpdateInventory) { _, newValue in
                            if newValue {
                                showingInventoryUpdateConfirmation = true
                            }
                        }
                        .padding(.trailing)
                        .padding(.vertical, 4)
                }
            }
            .padding(.vertical, 8)
            .padding(.leading)
            .background(Color(UIColor.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading) {
                HStack {
                    Text("Price")
                    TextField("$20.00", value: $price, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 8)
                .padding(.trailing)
                Divider()
                HStack {
                    Text("Location")
                    Spacer()
                    if location != nil {
                        Text(location?.name ?? "")
                            .lineLimit(1)
                        Button("Remove location", systemImage: "xmark.circle.fill") {
                            withAnimation {
                                location = nil
                            }
                        }
                        .buttonStyle(.plain)
                        .labelStyle(.iconOnly)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.secondary, .quaternary)
                        .tint(.secondary)
                    } else {
                        Button("Add location", systemImage: "location.fill") {
                            openLocationSearch = true
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.trailing)
                Divider()
                DatePicker("Date", selection: $date)
                    .padding(.trailing)
            }
            .padding(.vertical, 8)
            .padding(.leading)
            .background(Color(UIColor.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $openLocationSearch) {
            LocationSelectorView(locationInfo: $location)
        }
        .alert("Update Inventory?", isPresented: $showingInventoryUpdateConfirmation) {
            Button("Yes") { shouldUpdateInventory = true }
            Button("No") { shouldUpdateInventory = false }
        } message: {
            Text("Do you want to automatically update your item's current amount based on this purchase?")
        }
    }
}

#Preview {
    @Previewable @State var amountValue: Double?
    @Previewable @State var amountUnit: AcceptedUnit = .count
    @Previewable @State var price: Double?
    @Previewable @State var location: LocationInfo?
    @Previewable @State var date: Date = Date()
    
    NavigationStack {
        PurchaseInputView(amountValue: $amountValue, amountUnit: $amountUnit, price: $price, location: $location, date: $date, showUpdateInventoryToggle: true)
    }
}
