//
//  InputSectionView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/14/24.
//

import SwiftUI

struct InputSectionView<Content: View, Header: View>: View {
    let content: () -> Content
    var header: (() -> Header)?
    var isScrollView: Bool
    
    init(isScrollView: Bool = false, @ViewBuilder content: @escaping () -> Content, header: (() -> Header)?) {
        self.content = content
        self.isScrollView = isScrollView
        self.header = header
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let header {
                header()
            }
            VStack(alignment: .leading) {
                content()
            }
            .background(Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
            .clipped()
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}

#Preview {
    InputSectionView {
        
    } header: {
        Text("Header")
    }
}

extension InputSectionView {
    init(isScrollView: Bool = false, @ViewBuilder content: @escaping () -> Content) where Header == Never {
        self.init(isScrollView: isScrollView, content: content, header: nil)
    }
}
