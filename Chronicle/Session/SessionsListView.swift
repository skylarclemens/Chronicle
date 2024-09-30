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
    @Binding var date: Date
    
    var body: some View {
        if !sessions.isEmpty {
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
            .animation(.default, value: sessions)
        } else {
            ContentUnavailableView {
                Label {
                    Text("No sessions")
                } icon: {
                    Image(systemName: "book")
                }
            } description: {
                HStack(spacing: 0) {
                    Text("You don't have any saved sessions for ") +
                    Text(date, format: .dateTime.month().day()) +
                    Text(".")
                }
            }
        }
    }
    
    init(date: Binding<Date>, searchText: String) {
        _sessions = Query(filter: Session.predicate(date: date.wrappedValue, searchText: searchText), sort: \Session.createdAt, order: .reverse)
        self._date = date
    }
}

#Preview {
    @Previewable @State var date = Date()
    
    NavigationStack {
        SessionsListView(date: $date, searchText: "")
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
