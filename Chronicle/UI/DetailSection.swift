//
//  DetailSection.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import SwiftUI

struct DetailSection<Content: View>: View {
    let content: () -> Content
    var header: String?
    var headerRight: String?
    var isScrollView: Bool
    
    init(header: String? = nil, headerRight: String? = nil, isScrollView: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.header = header
        self.headerRight = headerRight
        self.isScrollView = isScrollView
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if header != nil || headerRight != nil {
                HStack {
                    if let header {
                        Text(header)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, isScrollView ? nil : 0)
                    }
                    Spacer()
                    if let headerRight {
                        Text(headerRight)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            content()
        }
        .padding(.horizontal, isScrollView ? 0 : nil)
        .padding(.vertical)
        .background(.regularMaterial,
                    in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DetailSection(header: "Header", headerRight: "test") {
        Text("Hello")
    }
}
