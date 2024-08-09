//
//  ContentView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("\(item.name) at \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))\nStrain: \(item.strain?.name ?? "no strain")")
                    } label: {
                        Text("\(item.name): \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    }
                }
            }
            .navigationTitle("Dashboard")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addExamples()
    
    return ContentView()
        .modelContainer(modelPreview.container)
}
