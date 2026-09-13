//
//  CalendarConfiguration.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-12.
//

import Foundation

public struct CalendarConfiguration {
    public var calendar: Calendar
    public var locale: CalendarLocale
    public var timeZone: CalendarTimeZone
    public var weekStart: CalendarWeekStart

    public init(
        calendar: Calendar = .current,
        locale: CalendarLocale = .system,
        timeZone: CalendarTimeZone = .system,
        weekStart: CalendarWeekStart = .system
    ) {
        self.calendar = calendar
        self.locale = locale
        self.timeZone = timeZone
        self.weekStart = weekStart
    }

    var configuredCalendar: Calendar {
        var calendar = calendar

        calendar.locale = locale.locale
        calendar.timeZone = timeZone.timeZone

        if let firstWeekday = weekStart.firstWeekday {
            calendar.firstWeekday = firstWeekday
        }

        return calendar
    }
}
