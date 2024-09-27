//
//  ColorSchemeViewModifier.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import SwiftUI

struct ColorSchemeViewModifier: ViewModifier {
    @AppStorage("selectedAppearance") var selectedAppearance: DisplayMode = .dark
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(selectedAppearance.colorScheme)
    }
}

extension View {
    func colorSchemeStyle() -> some View {
        modifier(ColorSchemeViewModifier())
    }
}
