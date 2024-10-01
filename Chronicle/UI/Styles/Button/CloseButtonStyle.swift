//
//  CloseButtonStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/1/24.
//

import SwiftUI

struct CloseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.secondary, .quaternary)
    }
}

extension ButtonStyle where Self == CloseButtonStyle {
    static var close: CloseButtonStyle {
        CloseButtonStyle()
    }
}
