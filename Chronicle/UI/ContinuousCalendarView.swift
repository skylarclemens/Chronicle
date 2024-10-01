//
//  ContinuousCalendarView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/30/24.
//

import SwiftUI
import SwiftData
import UIKit

struct ContinuousCalendarView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    var sessions: [Session]
    @Binding var selectedDate: Date

    @State private var currentMonth: Date = Date()
    @State private var monthFrames: [Date: CGRect] = [:]
    @State private var startDate: Date
    @State private var endDate: Date = Date()
    
    @State private var currentScrollDate: Date?
    
    private let calendar = Calendar.autoupdatingCurrent
    private let dateFormatter = DateFormatter()
    
    init(sessions: [Session] = [], selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self.sessions = sessions
        let start = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
        self._startDate = State(initialValue: start)
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 42) {
                        ForEach(getMonths()) { month in
                            MonthView(month: month, selectedDate: $selectedDate, sessions: sessions)
                                .id(month.date)
                        }
                    }
                    .padding()
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $currentScrollDate, anchor: .center)
                .onAppear {
                    calculateStartDate()
                    DispatchQueue.main.async {
                        currentScrollDate = selectedDate.startOfMonth
                    }
                }
            }
            .navigationTitle(Text(currentScrollDate ?? Date(), format: .dateTime.month(.wide).year()))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Today") {
                        selectedDate = Date()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .tint(.accent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.mini)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .safeAreaInset(edge: .top) {
                weekdaysView
            }
        }
    }
    
    @ViewBuilder var weekdaysView: some View {
        if let weekdays = dateFormatter.veryShortWeekdaySymbols {
            HStack(spacing: 24) {
                ForEach(0..<weekdays.count, id: \.self) { index in
                    Text(weekdays[index])
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(width: 30)
                }
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.bar)
            .overlay(
                Rectangle().frame(width: nil, height: 0.75,  alignment: .bottom).foregroundColor(.primary.opacity(0.1)),
                alignment: .bottom
            )
        }
    }
    
    /// Returns all of the months within the date range
    private func getMonths() -> [CalendarMonth] {
        guard startDate < endDate else { return [] }
        var date = startDate
        var dates: [CalendarMonth] = []
        while date.startOfMonth <= endDate.startOfMonth {
            dates.append(CalendarMonth(date: date.startOfMonth))
            guard let newDate = calendar.date(byAdding: .month, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    /// Gets start date based on earliest session logged
    private func calculateStartDate() {
        if let earliestSession = sessions.min(by: { $0.date < $1.date }),
            let earliestDate = calendar.date(from: calendar.dateComponents([.year, .month], from: earliestSession.date)) {
            startDate = earliestDate
        } else {
            startDate = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
        }
    }
}

struct MonthView: View {
    let month: CalendarMonth
    @Binding var selectedDate: Date
    let sessions: [Session]
    
    private let calendar = Calendar.autoupdatingCurrent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(month.date, format: .dateTime.month(.wide))
                .font(.system(.headline, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 28) {
                ForEach(1..<calendar.firstWeekday(for: month.date), id: \.self) { _ in
                    Rectangle()
                        .fill(.clear)
                }
                ForEach(month.days, id: \.self) { date in
                    if let date {
                        DayView(date: date, isSelected: Binding(get: {
                            calendar.isDate(date, inSameDayAs: selectedDate)
                        }, set: {
                            _ in selectedDate = date
                        }), hasSession: !sessionsForDate(date).isEmpty)
                    }
                }
            }
        }
        .frame(height: 350)
    }
    
//    private func getDaysInMonth() -> [Date] {
//        guard let monthRange = calendar.range(of: .day, in: .month, for: date) else { return [] }
//        let month = calendar.component(.month, from: date)
//        let year = calendar.component(.year, from: date)
//        
//        return monthRange.compactMap {
//            DateComponents(calendar: calendar, year: year, month: month, day: $0, hour: 0).date
//        }
//    }
    
    private func sessionsForDate(_ date: Date) -> [Session] {
        sessions.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

struct DayView: View {
    @Environment(\.dismiss) var dismiss
    let date: Date
    @Binding var isSelected: Bool
    let hasSession: Bool
    
    private let calendar = Calendar.autoupdatingCurrent
    
    var body: some View {
        VStack {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(.accent.opacity(0.25))
                        .frame(width: 30, height: 30)
                }
                if calendar.isDateInToday(date) && !isSelected {
                    Circle()
                        .fill(.primary.opacity(0.1))
                        .frame(width: 30, height: 30)
                }
                Text(date, format: .dateTime.day())
            }
            .frame(height: 24)
            Circle()
                .fill(hasSession ? .accent : .clear)
                .frame(width: 6, height: 6)
        }
        .frame(width: 30)
        .onTapGesture {
            isSelected = true
            dismiss()
        }
    }
}

struct CalendarMonth: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    
    var days: [Date?] {
        let calendar = Calendar.autoupdatingCurrent
        guard let monthRange = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return monthRange.compactMap {
            DateComponents(calendar: calendar, year: year, month: month, day: $0, hour: 0).date
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    let calendar = Calendar.autoupdatingCurrent
    
    NavigationStack {
        VStack {
            
        }
        .sheet(isPresented: .constant(true)) {
            ContinuousCalendarView(sessions: SampleData.shared.randomDatesSessions, selectedDate: $selectedDate)
        }
    }
    .modelContainer(SampleData.shared.container)
}
