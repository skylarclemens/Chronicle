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
                .font(.title2.weight(.semibold))
            if let description {
                VStack {
                    description()
                }
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom)
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
            Text("Default Units description.")
        }
    }
}
