//
//  DateFilter.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/25/24.
//

import Foundation
import SwiftUICore

enum DateFilter: String, CaseIterable {
    case week = "week"
    case month = "month"
    case year = "year"

    
    func dateRange() -> (Date, Date) {
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        switch self {
        case .week:
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfDay))!
            let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
            return (weekStart, weekEnd)
        case .month:
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: startOfDay))!
            let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
            return (monthStart, monthEnd)
        case .year:
            let yearStart = calendar.date(from: calendar.dateComponents([.year], from: startOfDay))!
            let yearEnd = calendar.date(byAdding: .year, value: 1, to: yearStart)!
            return (yearStart, yearEnd)
        }
    }
    
    var dateLabel: some View {
        switch self {
        case .week:
            Text(self.dateRange().0.formatted(date: .abbreviated, time: .omitted)) +
            Text("-") +
            Text(self.dateRange().1.formatted(date: .abbreviated, time: .omitted))
        case .month:
            Text(self.dateRange().0, format: .dateTime.month(.wide).year())
        case .year:
            Text(self.dateRange().0, format: .dateTime.year())
        }
    }
}
