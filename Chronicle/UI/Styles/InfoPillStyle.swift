//
//  InfoPillStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/28/24.
//

import SwiftUI

struct InfoPillStyle: ViewModifier {
    var color: Color?
    var horizontalSpacing: CGFloat = 10
    var verticalSpacing: CGFloat = 6
    var showBorder: Bool = true
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalSpacing)
            .padding(.vertical, verticalSpacing)
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
                if let color,
                    showBorder {
                    Capsule()
                        .strokeBorder(color.opacity(0.5), lineWidth: 1)
                } else if showBorder {
                    Capsule()
                        .strokeBorder(.tertiary, lineWidth: 1)
                }
            }
    }
}

extension View {
    func infoPillStyle(_ color: Color? = nil, horizontalSpacing: CGFloat = 10, verticalSpacing: CGFloat = 6, showBorder: Bool = true) -> some View {
        modifier(InfoPillStyle(color: color, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing, showBorder: showBorder))
    }
}
