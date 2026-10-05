//
//  TaskDateFormatting.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 16.09.2026.
//

import Foundation

enum TaskDateFormatting {
    static func dueLabel(for date: Date, calendar: Calendar, relativeTo now: Date = Date()) -> String {
        let today = calendar.startOfDay(for: now)
        let dueDay = calendar.startOfDay(for: date)

        if calendar.isDate(dueDay, inSameDayAs: today) {
            return "Today"
        }
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
           calendar.isDate(dueDay, inSameDayAs: tomorrow) {
            return "Tomorrow"
        }
        return dueDay.formatted(date: .numeric, time: .omitted)
    }
}
