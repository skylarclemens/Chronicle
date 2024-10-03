//
//  StrainListView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/3/24.
//

import SwiftUI
import SwiftData

struct StrainListView: View {
    @Query(sort: \Strain.name) private var strains: [Strain]
    
    var strainsByType: [StrainType: [Strain]] {
        Dictionary(grouping: strains, by: \.type)
    }
    
    var body: some View {
        if !strains.isEmpty {
            ForEach(StrainType.allCases) { strainType in
                if let typeStrains = strainsByType[strainType],
                   !typeStrains.isEmpty {
                    Section(strainType.rawValue.localizedCapitalized) {
                        ForEach(typeStrains) { strain in
                            NavigationLink {
                                StrainDetailsView(strain: strain)
                            } label: {
                                StrainRowView(strain: strain)
                            }
                            .listRowBackground(Color.clear.background(.thickMaterial))
                        }
                    }
                }
            }
            .animation(.default, value: strains)
        }
    }
    
    init(filter: InventoryFilter, sort: InventorySort, searchText: String) {
        _strains = Query(filter: Strain.predicate(filter: filter, searchText: searchText), sort: [sort.strainSortDescriptor()])
    }
}

#Preview {
    NavigationStack {
        List {
            StrainListView(filter: .all, sort: InventorySort.name, searchText: "")
        }
    }
    .modelContainer(SampleData.shared.container)
}
