//
//  SessionsListView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/29/24.
//

import SwiftUI
import SwiftData

struct SessionsListView: View {
    @Query private var sessions: [Session]
    
    var body: some View {
        List {
            ForEach(sessions) { session in
                ZStack {
                    SessionRowView(session: session)
                    NavigationLink(destination: SessionDetailsView(session:session)) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .animation(.default, value: sessions)
    }
    
    init(date: Date?) {
        _sessions = Query(filter: Session.predicate(date: date), sort: \Session.createdAt, order: .reverse)
    }
}

#Preview {
    NavigationStack {
        SessionsListView(date: Date())
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
