//
//  TestDateFactory.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import Foundation

func makeDate(
    year: Int,
    month: Int,
    day: Int,
    hour: Int = 0,
    minute: Int = 0
) throws -> Date {
    var calendar = Calendar(
        identifier: .gregorian
    )

    calendar.timeZone = TimeZone(
        secondsFromGMT: 0
    )!

    let components = DateComponents(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute
    )

    guard let date = calendar.date(
        from: components
    ) else {
        throw TestDateError.invalidDate
    }

    return date
}

enum TestDateError: Error {
    case invalidDate
}
