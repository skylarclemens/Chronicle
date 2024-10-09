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
                Text("Set default units for new items by item type. Units can be overridden when adding or editing individual items. Existing items are not affected by changing these values.")
            }
            Section {
                ForEach(ItemType.allCases) { itemType in
                    HStack {
                        Label {
                            Text(itemType.label())
                        } icon: {
                            Image(systemName: itemType.symbol())
                                .imageScale(.medium)
                        }
                        Spacer()
                        Picker("", selection: unitSelection(for: itemType)) {
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
    
    private func unitSelection(for itemType: ItemType) -> Binding<AcceptedUnit> {
        Binding(
            get: { self.unitManager.getDefaultUnit(for: itemType) },
            set: { self.unitManager.setDefaultUnit($0, for: itemType) }
        )
    }
}

#Preview {
    NavigationStack {
        UnitsSettingsView()
    }
}
