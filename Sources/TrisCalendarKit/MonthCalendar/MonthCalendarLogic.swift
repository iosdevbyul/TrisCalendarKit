//
//  MonthCalendarLogic.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import Foundation

struct MonthCalendarLogic {

    static func shouldNavigateToAdjacentMonth(
        day: CalendarDay,
        behavior: AdjacentMonthSelectionBehavior
    ) -> Bool {
        guard !day.isCurrentMonth else {
            return false
        }

        return behavior == .navigate
    }

    static func normalizedDates(
        _ dates: Set<Date>,
        calendar: Calendar
    ) -> Set<Date> {
        Set(
            dates.map {
                calendar.startOfDay(for: $0)
            }
        )
    }

    static func isHighlighted(
        _ date: Date,
        highlightedDates: Set<Date>,
        calendar: Calendar
    ) -> Bool {
        highlightedDates.contains(
            calendar.startOfDay(for: date)
        )
    }

    static func weekdaySymbols(
        calendar: Calendar
    ) -> [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1

        return Array(
            symbols[firstWeekdayIndex...] +
            symbols[..<firstWeekdayIndex]
        )
    }
}
