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
    @Query(sort: \Item.name) private var items: [Item]
    @State private var openAddItem: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("\(item.name) at \(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))\nStrain: \(item.strain?.name ?? "no strain")")
                    } label: {
                        Text("\(item.name): \(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    }
                }
            }
            .toolbar {
                Button {
                    self.openAddItem = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationTitle("Dashboard")
            .sheet(isPresented: $openAddItem) {
                Text("Add")
            }
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
