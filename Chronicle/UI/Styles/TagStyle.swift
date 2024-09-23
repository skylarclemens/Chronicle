//
//  TagStyle.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/23/24.
//

import SwiftUI

struct TagStyle: ViewModifier {
    var selected: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .rounded, weight: .semibold))
            .foregroundStyle(selected ? .primary : .secondary)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(selected ? .accent.opacity(0.5) : Color(UIColor.tertiarySystemFill),
                        in: RoundedRectangle(cornerRadius: 8)
            )
    }
}

extension View {
    func tagStyle(selected: Bool = false) -> some View {
        modifier(TagStyle(selected: selected))
    }
}
