//
//  PillStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/13/24.
//

import SwiftUICore

struct PillStyle: ViewModifier {
    var color: Color?
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                Group {
                    if let color {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.2))
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    }
                }
            )
    }
}

extension View {
    func pillStyle(_ color: Color? = nil) -> some View {
        modifier(PillStyle(color: color))
    }
}
