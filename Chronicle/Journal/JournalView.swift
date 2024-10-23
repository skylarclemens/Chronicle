//
//  JournalView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    @Query private var sessions: [Session]
    @Binding var selectedDate: Date
    @State private var selectedSession: Session?
    @State private var openCalendar: Bool = false
    @State private var openSearch: Bool = false
    @State private var searchText = ""
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                SessionsListView(date: $selectedDate, searchText: searchText)
            }
            .listStyle(.plain)
            .contentMargins(.bottom, 80)
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .top) {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(checkCloseDate().uppercased())
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .frame(height: 16)
                                .foregroundStyle(.secondary)
                            Text(selectedDate, format: .dateTime.month().day())
                                .font(.system(.title, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .onTapGesture {
                            selectedDate = Date()
                        }
                        .animation(.spring(), value: selectedDate)
                        Spacer()
                        Button {
                            openSearch = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.headline)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(.quaternary,
                                    in: Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(.quaternary)
                        )
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                        .sensoryFeedback(trigger: openSearch) { oldValue, newValue in
                            if newValue {
                                return .selection
                            }
                            return nil
                        }
                        Button {
                            openCalendar = true
                        } label: {
                            Image(systemName:"calendar")
                                .font(.headline)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(.quaternary,
                                    in: Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(.quaternary)
                        )
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                        .sensoryFeedback(trigger: openCalendar) { oldValue, newValue in
                            if newValue {
                                return .selection
                            }
                            return nil
                        }
                    }
                    .padding(.horizontal)
                    WeekScrollerView(sessions: sessions, selectedDate: $selectedDate)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            Rectangle().frame(width: nil, height: 0.75,  alignment: .bottom).foregroundColor(.primary.opacity(0.1)),
                            alignment: .bottom
                        )
                        .overlay(
                            Rectangle().frame(width: nil, height: 0.75,  alignment: .top).foregroundColor(.primary.opacity(0.1)).padding(.horizontal),
                            alignment: .top
                        )
                }
                .safeAreaPadding(.top)
                .background(.bar)
            }
            .background(
                BackgroundView()
            )
            .sheet(isPresented: $openCalendar) {
                ContinuousCalendarView(sessions: sessions, selectedDate: $selectedDate)
            }
            .sheet(isPresented: $openSearch) {
                SearchView(selectedSession: $selectedSession)
            }
            .onChange(of: selectedSession) { oldValue, newValue in
                if let session = newValue {
                    navigateToSession(session)
                    selectedSession = nil
                }
            }
            .navigationDestination(for: Session.self) { session in
                SessionDetailsView(session: session)
            }
            .addContentSheets()
        }
    }
    
    func checkCloseDate() -> String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(selectedDate) {
            return "Yesterday"
        } else if Calendar.current.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: selectedDate)
        }
    }
    
    private func navigateToSession(_ session: Session) {
        navigationPath.append(session)
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    
    JournalView(selectedDate: $selectedDate)
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
