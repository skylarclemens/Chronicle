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
    @Query(sort: \Session.createdAt) private var sessions: [Session]
    @State private var openAddItem: Bool = false
    @State private var openAddStrain: Bool = false
    @State private var openAddSession: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Stash")
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .padding(.horizontal)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(items) { item in
                                    NavigationLink {
                                        ItemDetailsView(item: item)
                                    } label: {
                                        ItemCardView(item: item)
                                    }
                                }
                            }
                            .tint(.primary)
                            .frame(maxHeight: 120)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    List {
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
                        Section("Sessions") {
                            if sessions.count > 0 {
                                ForEach(sessions) { session in
                                    NavigationLink {
                                        Text(session.item?.name ?? "")
                                        Text(session.createdAt, format: .dateTime)
                                    } label: {
                                        Text("Session")
                                    }
                                }
                                .onDelete(perform: removeSession)
                            }
                        }
                    }
                }
                .toolbar {
                    Menu("Add", systemImage: "plus") {
                        Button("Add Session") {
                            self.openAddSession = true
                        }
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
                .sheet(isPresented: $openAddSession) {
                    AddSessionView()
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
            try? modelContext.save()
        }
    }
    
    private func removeStrain(at offsets: IndexSet) {
        for i in offsets {
            let strain = strains[i]
            modelContext.delete(strain)
            try? modelContext.save()
        }
    }
    
    private func removeSession(at offsets: IndexSet) {
        for i in offsets {
            let session = sessions[i]
            modelContext.delete(session)
            try? modelContext.save()
        }
    }
}

#Preview {
    let modelPreview = ModelPreview()
    modelPreview.addExamples(sampleItems: Item.sampleItems)
    
    return ContentView()
        .modelContainer(modelPreview.container)
}
