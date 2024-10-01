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
    @Binding var activeTab: AppTab
    @State private var openAddSession: Bool = false
    @State private var openSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        SimpleAnalyticsView(activeTab: $activeTab)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Button {
                            openAddSession = true
                        } label: {
                            Label("Add a new session", systemImage: "plus")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        .tint(.accent)
                        .controlSize(.large)
                        .buttonBorderShape(.roundedRectangle(radius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.accent.opacity(0.33))
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top)
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
                                .buttonStyle(.bordered)
                                .tint(.accent)
                            }
                        }
                    }
                    .padding(.top)
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
                                                .background(.thickMaterial,
                                                            in: RoundedRectangle(cornerRadius: 8))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .strokeBorder(.primary.opacity(0.1))
                                                )
                                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .contentMargins(.horizontal, 16)
                            .scrollClipDisabled()
                        }
                        .padding(.vertical)
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "person.crop.circle") {
                        self.openSettings = true
                    }
                    .tint(.primary)
                }
            }
            .addContentSheets()
            .sheet(isPresented: $openAddSession) {
                SessionEditorView()
            }
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
    @Previewable @State var activeTab: AppTab = .dashboard
    DashboardView(activeTab: $activeTab)
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
