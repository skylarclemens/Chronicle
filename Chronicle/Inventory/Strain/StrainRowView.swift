//
//  StrainRowView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/3/24.
//

import SwiftUI

struct StrainRowView: View {
    var strain: Strain?
    var body: some View {
        if let strain {
            HStack {
                Image(systemName: "leaf")
                    .frame(width: 45, height: 45)
                    .foregroundStyle(.accent)
                    .background(.accent.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 8))
                Text(strain.name)
                if strain.favorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    StrainRowView(strain: SampleData.shared.strain)
        .modelContainer(SampleData.shared.container)
}
