//
//  TerpeneView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/13/24.
//

import SwiftUI

struct TerpeneView: View {
    var terpene: Compound
    
    init(_ terpene: Compound) {
        self.terpene = terpene
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(maxWidth: 3, maxHeight: 14)
                .foregroundStyle(terpene.color.color)
            Text(terpene.name)
        }
        .pillStyle(terpene.color.color)
    }
}

#Preview {
    TerpeneView(Compound.predefinedTerpenes[0])
}
