//
//  WeekScrollerView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/30/24.
//

import SwiftUI

struct WeekScrollerView: View {
    @Binding var selectedDate: Date
    @State private var currentDate: Date = Date()
    @State private var weekOffset: Int?
    @State private var currentWeek: Date?
    @State private var weeks: [Date] = []
    
    private let calendar = Calendar.autoupdatingCurrent
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<weeks.count, id: \.self) { index in
                        weekView(for: weeks[index])
                            .padding(.horizontal)
                            .frame(minWidth: proxy.size.width)
                            //.border(.accent, width: 1)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $weekOffset)
            .frame(height: 80)
            .onAppear {
                initializeWeeks()
            }
            .onChange(of: weekOffset) { oldValue, newValue in
                self.weekOffset = updateWeeks()
                print(weeks)
            }
        }
    }
    
    private func initializeWeeks() {
        let currentWeek = currentDate.startOfWeek
        weeks = (-2...2).compactMap { offset in
            calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeek)
        }
        weekOffset = 2
        self.currentWeek = currentWeek
    }
    
    private func updateWeeks() -> Int {
        if let weekOffset {
            var newWeekOffset = weekOffset
            let visibleWeeks = Set(weeks)
            let currentWeek = weeks[weekOffset]
            
            if weekOffset <= 1 {
                let newWeeks = (-2...(-1)).compactMap { offset in
                    calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeek)
                }.filter { !visibleWeeks.contains($0) }
                weeks.insert(contentsOf: newWeeks, at: 0)
                newWeekOffset += newWeeks.count
            }
            
            if weekOffset >= weeks.count - 2 {
                let newWeeks = (1...2).compactMap { offset in
                    let potentialWeek = calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeek)!
                    return potentialWeek <= Date().startOfWeek ? potentialWeek : nil
                }.filter { !visibleWeeks.contains($0) }
                weeks.append(contentsOf: newWeeks)
            }
            
            // Remove excess weeks
            if weeks.count > 5 {
                if weekOffset > 2 {
                    weeks.removeFirst(weeks.count - 5)
                    newWeekOffset = 2
                } else {
                    weeks.removeLast(weeks.count - 5)
                }
            }
            
            return newWeekOffset
        }
        return 0
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
        
        return VStack {
            Text(dateFormatter.veryShortStandaloneWeekdaySymbols[calendar.component(.weekday, from: date) - 1])
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(date, format: .dateTime.day())
                .font(.headline)
                .foregroundStyle(isAfterToday ? .tertiary : .primary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(isSelected ? .accent.opacity(0.25) : (isToday ? .primary.opacity(0.1) : .clear),
                    in: RoundedRectangle(cornerRadius: 8))
        .onTapGestureIf(!isAfterToday, closure: {
            withAnimation {
                selectedDate = date
            }
        })
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    WeekScrollerView(selectedDate: $selectedDate)
}
