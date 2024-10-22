//
//  EditorInputButton.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/11/24.
//

import SwiftUI

struct EditorInputButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.regularMaterial,
                        in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(.quaternary)
            )
    }
}

extension ButtonStyle where Self == EditorInputButton {
    static var editorInput: Self {
        EditorInputButton()
    }
}
