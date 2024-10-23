//
//  AddButtonStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/22/24.
//

import Foundation
import SwiftUI

struct AddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

extension ButtonStyle where Self == AddButtonStyle {
    static var add: Self {
        AddButtonStyle()
    }
}
