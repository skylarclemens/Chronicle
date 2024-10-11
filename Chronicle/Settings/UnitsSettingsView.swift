//
//  UnitsSettingsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/8/24.
//

import SwiftUI

struct UnitsSettingsView: View {
    @State private var unitManager = UnitManager.shared
    var color: Color = .accent
    
    var body: some View {
        List {
            SettingsHeader("Default Units", systemImage: "lines.measurement.vertical", color: color) {
                Text("Set default units for item amount and dosage for new items. Units can be overridden when adding or editing individual items. Existing items are not affected by changing these values.")
            }
            Section("Amounts") {
                ForEach(ItemType.allCases) { itemType in
                    HStack {
                        Label {
                            Text(itemType.label())
                        } icon: {
                            Image(systemName: itemType.symbol())
                                .imageScale(.medium)
                        }
                        Spacer()
                        Picker("", selection: amountUnitSelection(for: itemType)) {
                            ForEach(AcceptedUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            Section("Dosages") {
                ForEach(ItemType.allCases) { itemType in
                    HStack {
                        Label {
                            Text(itemType.label())
                        } icon: {
                            Image(systemName: itemType.symbol())
                                .imageScale(.medium)
                        }
                        Spacer()
                        Picker("", selection: dosageUnitSelection(for: itemType)) {
                            ForEach(AcceptedUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
        }
    }
    
    private func amountUnitSelection(for itemType: ItemType) -> Binding<AcceptedUnit> {
        Binding(
            get: { self.unitManager.getAmountUnit(for: itemType) },
            set: { self.unitManager.setAmountUnit($0, for: itemType) }
        )
    }
    
    private func dosageUnitSelection(for itemType: ItemType) -> Binding<AcceptedUnit> {
        Binding(
            get: { self.unitManager.getDosageUnit(for: itemType) },
            set: { self.unitManager.setDosageUnit($0, for: itemType) }
        )
    }
}

#Preview {
    NavigationStack {
        UnitsSettingsView()
    }
}
