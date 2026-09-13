//
//  CalendarGenerator.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-13.
//

import Foundation

public struct CalendarGenerator {
    private let configuration: CalendarConfiguration

    public init(
        configuration: CalendarConfiguration = CalendarConfiguration()
    ) {
        self.configuration = configuration
    }

    public func makeMonthDays(
        for date: Date
    ) -> [CalendarDay] {
        let calendar = configuration.configuredCalendar

        guard
            let monthInterval = calendar.dateInterval(
                of: .month,
                for: date
            ),
            let firstWeekInterval = calendar.dateInterval(
                of: .weekOfMonth,
                for: monthInterval.start
            ),
            let lastDateOfMonth = calendar.date(
                byAdding: .day,
                value: -1,
                to: monthInterval.end
            ),
            let lastWeekInterval = calendar.dateInterval(
                of: .weekOfMonth,
                for: lastDateOfMonth
            )
        else {
            return []
        }

        let startDate = firstWeekInterval.start
        let endDate = lastWeekInterval.end

        var days: [CalendarDay] = []
        var currentDate = startDate

        while currentDate < endDate {
            days.append(
                CalendarDay(
                    date: currentDate,
                    isCurrentMonth: calendar.isDate(
                        currentDate,
                        equalTo: date,
                        toGranularity: .month
                    ),
                    isToday: calendar.isDateInToday(currentDate)
                )
            )

            guard let nextDate = calendar.date(
                byAdding: .day,
                value: 1,
                to: currentDate
            ) else {
                break
            }

            currentDate = nextDate
        }

        return days
    }
}
