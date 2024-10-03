//
//  ItemTypeDistributionChartView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/2/24.
//

import SwiftUICore
import Charts

struct ItemTypeDistributionChart: View {
    var items: [Item]
    
    var body: some View {
        Chart(itemTypeDistribution(), id: \.type) { typeData in
            SectorMark(
                angle: .value("Count", typeData.count),
                innerRadius: .ratio(0.55),
                angularInset: 3.0
            )
            .cornerRadius(8.0)
            .foregroundStyle(by: .value("Type", typeData.type.label()))
        }
    }
    
    private func itemTypeDistribution() -> [(type: ItemType, count: Int)] {
        let typeCounts = items.compactMap { $0.type }
            .reduce(into: [:]) { counts, type in
                counts[type, default: 0] += 1
            }
        return typeCounts.map { (type: $0.key, count: $0.value) }.sorted {
            $0.type.rawValue < $1.type.rawValue
        }
    }
}
