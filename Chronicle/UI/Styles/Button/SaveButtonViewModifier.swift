//
//  SaveButtonViewModifier.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/19/24.
//

import Foundation
import SwiftUI

struct SaveButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.accent)
            .background(.background,
                        in: RoundedRectangle(cornerRadius: 8))
            .padding()
    }
}

extension View {
    func saveButton() -> some View {
        modifier(SaveButtonViewModifier())
    }
}

#Preview {
    ZStack {
        Text("Example background text. Lorem ipsum.")
        Button("Save") {
            
        }
        .saveButton()
    }
}
