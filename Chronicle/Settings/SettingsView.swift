//
//  SettingsView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/27/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AppearanceView()
                    } label: {
                        Label("Appearance", systemImage: "paintpalette")
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .tint(.secondary)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
