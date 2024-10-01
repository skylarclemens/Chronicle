//
//  WeekScrollerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/30/24.
//

import SwiftUI
import SwiftData

struct WeekScrollerView: View {
    var sessions: [Session] = []
    
    @Binding var selectedDate: Date
    @State private var weekOffset: Int?
    @State private var weeks: [Date] = []
    
    private let calendar = Calendar.autoupdatingCurrent
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        let weekOffsetBinding = Binding<Int?>(get: {
            return self.weekOffset
        }, set: {
            self.weekOffset = $0
            if let newOffset = $0 {
                updateSelectedDateForNewWeek(weekIndex: newOffset)
            }
        })
        
        GeometryReader { proxy in
            VStack {
                weekdaysView
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<weeks.count, id: \.self) { index in
                            weekView(for: weeks[index])
                                .padding(.horizontal)
                                .frame(minWidth: proxy.size.width)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: weekOffsetBinding)
                .onAppear {
                    initializeWeeks()
                }
                .onChange(of: selectedDate) { oldValue, newValue in
                    if let weekOffset,
                       newValue.startOfWeek != weeks[weekOffset],
                       let newWeekOffset = weeks.firstIndex(of: newValue.startOfWeek) {
                        withAnimation {
                            self.weekOffset = newWeekOffset
                        }
                    }
                }
            }
        }
        .frame(height: 65)
    }
    
    private func initializeWeeks() {
        let currentWeek = Date().startOfWeek
        let numOfWeeks = calculateNumOfWeeks(for: Date())
        weeks = (-numOfWeeks...0).compactMap { offset in
            calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeek)
        }
        let selectedWeekStart = selectedDate.startOfWeek
        if let selectedWeekIndex = weeks.firstIndex(of: selectedWeekStart) {
            weekOffset = selectedWeekIndex
        } else {
            weekOffset = numOfWeeks
        }
    }
    
    private func sessionsForDate(_ date: Date) -> [Session] {
        sessions.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    /// Gets start date based on earliest session logged
    private func calculateNumOfWeeks(for date: Date) -> Int {
        if let earliestSession = sessions.min(by: { $0.date < $1.date }),
            let earliestDate = calendar.date(from: calendar.dateComponents([.year, .month], from: earliestSession.date)) {
                let numOfWeeks = calendar.dateComponents([.weekOfYear], from: earliestDate, to: date).weekOfYear ?? 0
                return numOfWeeks
        } else {
            return 2
        }
    }
    
    private func updateSelectedDateForNewWeek(weekIndex: Int) {
        let newWeekStart = weeks[weekIndex]
        let currentWeekday = calendar.component(.weekday, from: selectedDate)
        if let newDate = calendar.date(bySetting: .weekday, value: currentWeekday, of: newWeekStart) {
            withAnimation {
                if newDate.startOfDay > Date().startOfDay {
                    selectedDate = Date()
                } else {
                    selectedDate = newDate
                }
            }
        }
    }
    
    @ViewBuilder var weekdaysView: some View {
        if let weekdays = dateFormatter.veryShortWeekdaySymbols {
            HStack {
                ForEach(0..<weekdays.count, id: \.self) { index in
                    Text(weekdays[index])
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func weekView(for date: Date) -> some View {
        return HStack(spacing: 8) {
            ForEach(0..<7) { dayOffset in
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: date.startOfWeek) {
                    dayView(for: date)
                }
            }
        }
    }
    
    private func dayView(for date: Date) -> some View {
        let isSelected = calendar.isDate(selectedDate, inSameDayAs: date)
        let isToday = calendar.isDateInToday(date)
        let isAfterToday = Date().startOfDay < date.startOfDay
        
        return ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? .accent.opacity(0.25) : (isToday ? .primary.opacity(0.1) : .clear))
                .padding(.horizontal, 4)
            VStack(spacing: 2) {
                Text(date, format: .dateTime.day())
                    .font(.headline)
                    .foregroundStyle(isAfterToday ? .tertiary : .primary)
                Circle()
                    .fill(!sessionsForDate(date).isEmpty ? .accent : .clear)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onTapGestureIf(!isAfterToday, closure: {
            withAnimation {
                selectedDate = date
            }
        })
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    WeekScrollerView(sessions: SampleData.shared.randomDatesSessions, selectedDate: $selectedDate)
        .modelContainer(SampleData.shared.container)
}
