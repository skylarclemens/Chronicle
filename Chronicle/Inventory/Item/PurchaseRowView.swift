//
//  PurchaseRowView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/15/24.
//

import SwiftUI

struct PurchaseRowView: View {
    var purchase: Purchase?
    
    var body: some View {
        if let purchase {
            VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 0) {
                        Text("Purchased on ")
                            .foregroundStyle(.secondary)
                        Text(purchase.date.formatted(date: .abbreviated, time: .omitted))
                            .fontWeight(.semibold)
                    }
                    .fontDesign(.rounded)
                }
                VStack(spacing: 12) {
                    HStack {
                        Label("Price", systemImage: "dollarsign")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(purchase.price ?? 0, format: .currency(code: "USD"))
                    }
                    if let location = purchase.location {
                        Divider()
                        HStack {
                            Label("Location", systemImage: "location")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(location.name ?? "")
                        }
                    }
                    if let amount = purchase.amount {
                        Divider()
                        HStack {
                            Label("Amount", systemImage: "scalemass")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(amount.value, format: .number) +
                            Text(" \(amount.unit.rawValue)")
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color(.tertiarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    PurchaseRowView(purchase: SampleData.shared.purchase)
        .modelContainer(SampleData.shared.container)
}
