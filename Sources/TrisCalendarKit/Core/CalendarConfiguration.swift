//
//  CalendarConfiguration.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-12.
//

import Foundation

public struct CalendarConfiguration {
    public var calendar: Calendar
    public var locale: Locale
    public var timeZone: TimeZone

    public init(
        calendar: Calendar = .current,
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) {
        var configuredCalendar = calendar
        configuredCalendar.locale = locale
        configuredCalendar.timeZone = timeZone

        self.calendar = configuredCalendar
        self.locale = locale
        self.timeZone = timeZone
    }
}
