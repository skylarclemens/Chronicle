//
//  DashboardView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.name) private var items: [Item]
    @Query(sort: \Strain.name) private var strains: [Strain]
    @Query(Session.dashboardDescriptor) private var sessions: [Session]
    @State private var openAddItem: Bool = false
    @State private var openAddStrain: Bool = false
    @State private var openAddSession: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            SimpleAnalyticsView()
                        }
                        .padding(.horizontal)
                        VStack(alignment: .leading) {
                            Text("Stash")
                                .font(.title2)
                                .padding(.horizontal)
                                .bold()
                                .accessibilityAddTraits(.isHeader)
                            if !items.isEmpty {
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
                            } else {
                                ContentUnavailableView {
                                    Label("Nothing in your stash", systemImage: "tray")
                                } description: {
                                    Text("You don't have any saved items.")
                                } actions: {
                                    Button {
                                        openAddItem = true
                                    } label: {
                                        Label("Add Item", systemImage: "plus")
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                        }
                        .padding(.vertical)
                        
                        VStack(alignment: .leading) {
                            Text("Recent Sessions")
                                .font(.title2)
                                .bold()
                                .accessibilityAddTraits(.isHeader)
                            if !sessions.isEmpty {
                                LazyVStack(spacing: 16) {
                                    ForEach(sessions, id: \.id) { session in
                                        NavigationLink {
                                            SessionDetailsView(session: session)
                                        } label: {
                                            CompactSessionCardView(session: session)
                                        }
                                    }
                                }
                                .animation(.default, value: sessions)
                                .tint(.primary)
                            } else {
                                ContentUnavailableView {
                                    Label("Nothing in your journal", systemImage: "book")
                                } description: {
                                    Text("You don't have any saved journal sessions.")
                                } actions: {
                                    Button {
                                        openAddSession = true
                                    } label: {
                                        Label("Add Session", systemImage: "plus")
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                        }
                        .padding(.horizontal)
                        if !strains.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Strains")
                                    .font(.title2)
                                    .padding(.horizontal)
                                    .bold()
                                    .accessibilityAddTraits(.isHeader)
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(strains) { strain in
                                            NavigationLink {
                                                StrainDetailsView(strain: strain)
                                            } label: {
                                                VStack {
                                                    HStack {
                                                        Image(systemName: "leaf")
                                                            .foregroundStyle(.accent)
                                                        Text(strain.name)
                                                    }
                                                    .tint(.primary)
                                                    .padding(8)
                                                    .background(RoundedRectangle(cornerRadius: 8).fill(.regularMaterial))
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            .containerRelativeFrame(
                                [.horizontal],
                                alignment: .topLeading
                            )
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Settings", systemImage: "person.crop.circle") {
                            
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
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
                }
                .navigationTitle("Dashboard")
                .sheet(isPresented: $openAddItem) {
                    ItemEditorView()
                }
                .sheet(isPresented: $openAddStrain) {
                    StrainEditorView()
                }
                .sheet(isPresented: $openAddSession) {
                    SessionEditorView()
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
        }
    }
}

#Preview {
    return DashboardView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
