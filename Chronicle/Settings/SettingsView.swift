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
                        Label {
                            Text("Appearance")
                        } icon: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.indigo)
                                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                                Image(systemName: "paintpalette")
                                    .foregroundStyle(.white)
                                    .imageScale(.medium)
                                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                            }
                            .frame(width: 28, height: 28, alignment: .center)
                        }
                    }
                }
                Section {
                    NavigationLink {
                        UnitsSettingsView(color: .orange)
                    } label: {
                        Label {
                            Text("Default Units")
                        } icon: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.orange)
                                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                                Image(systemName: "lines.measurement.vertical")
                                    .foregroundStyle(.white)
                                    .imageScale(.medium)
                                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                            }
                            .frame(width: 28, height: 28, alignment: .center)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
