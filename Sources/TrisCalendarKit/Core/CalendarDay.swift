//
//  CalendarDay.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-12.
//

import Foundation

public struct CalendarDay: Identifiable, Hashable {
    public let date: Date
    public let isCurrentMonth: Bool
    public let isToday: Bool

    public var id: Date {
        date
    }

    public init(
        date: Date,
        isCurrentMonth: Bool,
        isToday: Bool
    ) {
        self.date = date
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
    }
}
