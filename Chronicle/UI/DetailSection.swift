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
    
    init(header: String? = nil, isScrollView: Bool = false, @ViewBuilder content: @escaping () -> Content, headerRight: (() -> HeaderRight)?) {
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
                            .font(.title3)
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
        .background(Color(uiColor: UIColor.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DetailSection(header: "Header") {
        Text("Hello")
    }
}

extension DetailSection {
    init(header: String? = nil, isScrollView: Bool = false, @ViewBuilder content: @escaping () -> Content) where HeaderRight == Never {
        self.init(header: header, isScrollView: isScrollView, content: content, headerRight: nil)
    }
}
