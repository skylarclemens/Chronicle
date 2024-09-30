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
    @State private var openAddSelector: Bool = false
    @State private var openAddItem: Bool = false
    @State private var openAddStrain: Bool = false
    @State private var openAddSession: Bool = false
    @State private var openAddAccessory: Bool = false
    @State private var openSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
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
                .frame(maxHeight: .infinity)
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "person.crop.circle") {
                        self.openSettings = true
                    }
                    .tint(.primary)
                }
            }
            .navigationTitle("Dashboard")
            .addContentSheets()
            .sheet(isPresented: $openSettings) {
                SettingsView()
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
