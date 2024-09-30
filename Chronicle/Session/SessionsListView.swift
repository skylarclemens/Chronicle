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
    @Binding var openCalendar: Bool
    
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
            .sheet(isPresented: $openCalendar) {
                ContinuousCalendarView(selectedDate: $date)
            }
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
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }
    
    init(date: Binding<Date>, searchText: String, openCalendar: Binding<Bool>) {
        _sessions = Query(filter: Session.predicate(date: date.wrappedValue, searchText: searchText), sort: \Session.createdAt, order: .reverse)
        self._date = date
        self._openCalendar = openCalendar
    }
}

#Preview {
    @Previewable @State var date = Date()
    @Previewable @State var openCalendar = false
    
    NavigationStack {
        SessionsListView(date: $date, searchText: "", openCalendar: $openCalendar)
    }
    .modelContainer(SampleData.shared.container)
    .environment(ImageViewManager())
}
