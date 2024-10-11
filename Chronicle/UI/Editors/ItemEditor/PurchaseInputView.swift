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
    @State private var openLocationSearch: Bool = false
    
    var body: some View {
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
            Divider()
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
        .sheet(isPresented: $openLocationSearch) {
            LocationSelectorView(locationInfo: $location)
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
        PurchaseInputView(amountValue: $amountValue, amountUnit: $amountUnit, price: $price, location: $location, date: $date)
    }
}
