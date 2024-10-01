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
    @State private var openCalendar: Bool = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                SessionsListView(date: $selectedDate, searchText: searchText)
            }
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
                    }
                    .padding(.horizontal)
                    WeekScrollerView(sessions: sessions, selectedDate: $selectedDate)
                        .padding(.vertical, 12)
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
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                }
            }
            .sheet(isPresented: $openCalendar) {
                ContinuousCalendarView(sessions: sessions, selectedDate: $selectedDate)
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
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    
    JournalView(selectedDate: $selectedDate)
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
