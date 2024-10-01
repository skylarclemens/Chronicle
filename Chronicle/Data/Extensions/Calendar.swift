//
//  Calendar.swift
//  Chronicle
//
//  Created by Skylar Clemens on 9/30/24.
//

import Foundation

extension Calendar {
    func firstWeekday(for date: Date) -> Int {
        return self.component(.weekday, from: date.startOfMonth)
    }
}
