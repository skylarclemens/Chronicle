//
//  SessionInputButton.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import SwiftUI

struct SessionInputButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.regularMaterial,
                        in: RoundedRectangle(cornerRadius: 50))
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .strokeBorder(.quaternary)
            )
    }
}
