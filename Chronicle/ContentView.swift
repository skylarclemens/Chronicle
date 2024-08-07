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
                        Text("Item at \(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.date, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
            }
            .navigationTitle("Dashboard")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            Item.self,
            Strain.self,
            Experience.self
        ], inMemory: true)
}
