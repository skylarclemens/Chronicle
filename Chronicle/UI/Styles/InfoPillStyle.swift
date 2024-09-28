//
//  InfoPillStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct InfoPillStyle: ViewModifier {
    var color: Color?
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                Group {
                    if let color {
                        Capsule()
                            .fill(color.opacity(0.15))
                    } else {
                        Capsule()
                            .fill(.ultraThickMaterial)
                    }
                }
            )
            .overlay {
                if let color {
                    Capsule()
                        .strokeBorder(color.opacity(0.5), lineWidth: 1)
                } else {
                    Capsule()
                        .strokeBorder(.tertiary, lineWidth: 1)
                }
            }
    }
}

extension View {
    func infoPillStyle(_ color: Color? = nil) -> some View {
        modifier(InfoPillStyle(color: color))
    }
}
