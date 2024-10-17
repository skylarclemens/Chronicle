//
//  SettingsHeader.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/9/24.
//

import SwiftUI

struct SettingsHeader<Description: View>: View {
    var title: String
    var systemImage: String?
    var color: Color
    var description: (() -> Description)?
    
    @State private var isExpanded: Bool = false
    @State private var hasMoreText: Bool = false
    
    init(_ title: String, systemImage: String? = nil, color: Color = .accent, description: (() -> Description)? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
        self.description = description
    }
    
    var body: some View {
        Section {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.largeTitle.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(color,
                                in: RoundedRectangle(cornerRadius: 12))
                    .padding(.top)
            }
            Text(title)
                .headerTitle()
            if let description {
                VStack {
                    description()
                    if hasMoreText {
                        Text(isExpanded ? "Read less" : "Read more")
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                    }
                }
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .lineLimit(isExpanded ? nil : 4)
                .padding(.bottom)
                .overlay {
                    GeometryReader { outerProxy in
                        description()
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .overlay {
                                GeometryReader { innerProxy in
                                    Color.clear
                                        .onAppear {
                                            hasMoreText = innerProxy.size.height > outerProxy.size.height
                                        }
                                }
                            }
                            .hidden()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 2, leading: 16, bottom: 2, trailing: 16))
    }
}

#Preview {
    List {
        SettingsHeader("Default Units", systemImage: "lines.measurement.vertical") {
            Text("Set default units for item amount and dosage for new items. Units can be overridden when adding or editing individual items. Existing items are not affected by changing these values.")
        }
    }
}
