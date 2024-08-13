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
    @Query(sort: \Strain.name) private var strains: [Strain]
    @State private var openAddItem: Bool = false
    @State private var openAddStrain: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section("Items") {
                        ForEach(items) { item in
                            NavigationLink {
                                VStack {
                                    if let imagesData = item.imagesData,
                                       !imagesData.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack(spacing: 8) {
                                                ForEach(imagesData, id: \.self) { data in
                                                    if let uiImage = UIImage(data: data) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 150, height: 150, alignment: .leading)
                                                            .clipShape(.rect(cornerRadius: 10))
                                                    }
                                                }
                                            }
                                            .padding()
                                        }
                                    }
                                    Text("\(item.name) at \(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))\nStrain: \(item.strain?.name ?? "no strain")")
                                }
                            } label: {
                                Text("\(item.name): \(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            }
                        }
                        .onDelete(perform: removeItem)
                    }
                    Section("Strains") {
                        ForEach(strains) { strain in
                            NavigationLink {
                                Text("\(strain.name)")
                            } label: {
                                Text("\(strain.name)")
                            }
                        }
                        .onDelete(perform: removeStrain)
                    }
                }
                .toolbar {
                    Menu("Add", systemImage: "plus") {
                        Button("Add Item") {
                            self.openAddItem = true
                        }
                        Button("Add Strain") {
                            self.openAddStrain = true
                        }
                    }
                    
                }
                .navigationTitle("Dashboard")
                .sheet(isPresented: $openAddItem) {
                    AddItemView()
                }
                .sheet(isPresented: $openAddStrain) {
                    AddStrainView()
                }
            }
            .scrollContentBackground(.hidden)
            .preferredColorScheme(.dark)
            .background(
                BackgroundView()
            )
        }
        
    }
    
    private func removeItem(at offsets: IndexSet) {
        for i in offsets {
            let item = items[i]
            modelContext.delete(item)
        }
    }
    
    private func removeStrain(at offsets: IndexSet) {
        for i in offsets {
            let strain = strains[i]
            modelContext.delete(strain)
        }
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addExamples() 
    
    return ContentView()
        .modelContainer(modelPreview.container)
}
