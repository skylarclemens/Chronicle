//
//  DetailSection.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/21/24.
//

import SwiftUI

struct DetailSection<Content: View, HeaderRight: View>: View {
    let content: () -> Content
    var header: String?
    var headerRight: (() -> HeaderRight)?
    var isScrollView: Bool
    var showBackground: Bool
    
    init(header: String? = nil, isScrollView: Bool = false, showBackground: Bool = true, @ViewBuilder content: @escaping () -> Content, headerRight: (() -> HeaderRight)?) {
        self.content = content
        self.header = header
        self.headerRight = headerRight
        self.isScrollView = isScrollView
        self.showBackground = showBackground
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if header != nil || headerRight != nil {
                HStack {
                    if let header {
                        Text(header)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, isScrollView ? nil : 0)
                    }
                    Spacer()
                    if let headerRight {
                        headerRight()
                    }
                }
            }
            content()
        }
        .padding(.horizontal, isScrollView ? 0 : nil)
        .padding(.vertical)
        .background(showBackground ? Color(uiColor: UIColor.secondarySystemGroupedBackground) : .clear,
                    in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DetailSection(header: "Header") {
        Text("Hello")
    }
}

extension DetailSection {
    init(header: String? = nil, isScrollView: Bool = false, showBackground: Bool = true, @ViewBuilder content: @escaping () -> Content) where HeaderRight == Never {
        self.init(header: header, isScrollView: isScrollView, showBackground: showBackground, content: content, headerRight: nil)
    }
}
