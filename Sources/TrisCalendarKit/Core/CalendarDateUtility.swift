//
//  CalendarDateUtility.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-19.
//

import Foundation

enum CalendarDateUtility {

    static func normalize(
        _ date: Date,
        calendar: Calendar
    ) -> Date {
        calendar.startOfDay(
            for: date
        )
    }

    static func normalize(
        _ dates: Set<Date>,
        calendar: Calendar
    ) -> Set<Date> {
        Set(
            dates.map {
                calendar.startOfDay(
                    for: $0
                )
            }
        )
    }

    static func contains(
        _ date: Date,
        in normalizedDates: Set<Date>,
        calendar: Calendar
    ) -> Bool {
        normalizedDates.contains(
            normalize(
                date,
                calendar: calendar
            )
        )
    }

    static func isSameDay(
        _ lhs: Date,
        _ rhs: Date,
        calendar: Calendar
    ) -> Bool {
        calendar.isDate(
            lhs,
            inSameDayAs: rhs
        )
    }
}
