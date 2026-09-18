//
//  CalendarDay.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-12.
//

import Foundation

struct CalendarDay: Identifiable, Hashable {
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool

    var id: Date {
        date
    }
}
