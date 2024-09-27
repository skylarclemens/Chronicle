//
//  AppearanceView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import SwiftUI

struct AppearanceView: View {
    @AppStorage("selectedAppearance") var selectedAppearance: DisplayMode = .dark
    
    var body: some View {
        Form {
            Picker("Appearance", selection: $selectedAppearance) {
                Text("System").tag(DisplayMode.system)
                Text("Light").tag(DisplayMode.light)
                Text("Dark").tag(DisplayMode.dark)
            }.pickerStyle(.inline)
                .labelsHidden()
        }
        .navigationTitle("Appearance")
    }
}

#Preview {
    AppearanceView()
}
