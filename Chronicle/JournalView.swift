//
//  JournalView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/20/24.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    @State private var date: Date = Date()
    @State private var openCalendar: Bool = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(checkCloseDate().uppercased())
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .frame(height: 16)
                            .foregroundStyle(.secondary)
                        Text(date, format: .dateTime.month().day())
                            .font(.system(.title, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onTapGesture {
                        date = Date()
                    }
                    .animation(.spring(), value: date)
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
                WeekScrollerView(selectedDate: $date)
                    .frame(height: 80)
                List {
                    SessionsListView(date: $date, searchText: searchText, openCalendar: $openCalendar)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                BackgroundView()
            )
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                }
            }
            .addContentSheets()
        }
    }
    
    func checkCloseDate() -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
    }
}

#Preview {
    return JournalView()
        .modelContainer(SampleData.shared.container)
        .environment(ImageViewManager())
}
