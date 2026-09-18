//
//  CalendarDateUtilityTests.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-19.
//

import Foundation
import Testing

@testable import TrisCalendarKit

struct CalendarDateUtilityTests {

    @Test
    func normalizesDateToStartOfDay() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 19,
            hour: 21,
            minute: 30
        )

        let expected = try makeDate(
            year: 2026,
            month: 9,
            day: 19
        )

        let result =
            CalendarDateUtility.normalize(
                date,
                calendar: calendar
            )

        #expect(result == expected)
    }

    @Test
    func normalizesDateSet() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let first = try makeDate(
            year: 2026,
            month: 9,
            day: 19,
            hour: 10
        )

        let second = try makeDate(
            year: 2026,
            month: 9,
            day: 20,
            hour: 22
        )

        let result =
            CalendarDateUtility.normalize(
                [first, second],
                calendar: calendar
            )

        let expectedFirst = try makeDate(
            year: 2026,
            month: 9,
            day: 19
        )

        let expectedSecond = try makeDate(
            year: 2026,
            month: 9,
            day: 20
        )

        #expect(
            result.contains(
                expectedFirst
            )
        )

        #expect(
            result.contains(
                expectedSecond
            )
        )
    }

    @Test
    func findsDateRegardlessOfTime() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let storedDate = try makeDate(
            year: 2026,
            month: 9,
            day: 19,
            hour: 22
        )

        let targetDate = try makeDate(
            year: 2026,
            month: 9,
            day: 19,
            hour: 8
        )

        let normalized =
            CalendarDateUtility.normalize(
                [storedDate],
                calendar: calendar
            )

        let result =
            CalendarDateUtility.contains(
                targetDate,
                in: normalized,
                calendar: calendar
            )

        #expect(result)
    }
}
