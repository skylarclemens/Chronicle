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
                            .headerTitle()
                            .accessibilityAddTraits(.isHeader)
                        if !sessions.isEmpty {
                            LazyVStack(spacing: 16) {
                                ForEach(sessions, id: \.id) { session in
                                    NavigationLink {
                                        SessionDetailsView(session: session)
                                    } label: {
                                        SessionRowView(session: session)
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
                }
                .frame(maxHeight: .infinity)
            }
            .contentMargins(.bottom, 80)
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
            .addContentSheets()
        }
    }
}

#Preview {
    @Previewable @State var activeTab: AppTab = .dashboard
    DashboardView(activeTab: $activeTab)
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
