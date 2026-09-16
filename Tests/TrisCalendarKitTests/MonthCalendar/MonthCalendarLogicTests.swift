//
//  MonthCalendarLogicTests.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import Foundation
import Testing

@testable import TrisCalendarKit

struct MonthCalendarLogicTests {

    @Test
    func navigatesWhenAdjacentDayUsesNavigateBehavior() throws {
        let date = try makeDate(
            year: 2026,
            month: 10,
            day: 1
        )

        let day = CalendarDay(
            date: date,
            isCurrentMonth: false,
            isToday: false
        )

        let result = MonthCalendarLogic
            .shouldNavigateToAdjacentMonth(
                day: day,
                behavior: .navigate
            )

        #expect(result)
    }

    @Test
    func doesNotNavigateWhenAdjacentDayUsesSelectOnlyBehavior() throws {
        let date = try makeDate(
            year: 2026,
            month: 10,
            day: 1
        )

        let day = CalendarDay(
            date: date,
            isCurrentMonth: false,
            isToday: false
        )

        let result = MonthCalendarLogic
            .shouldNavigateToAdjacentMonth(
                day: day,
                behavior: .selectOnly
            )

        #expect(!result)
    }

    @Test
    func doesNotNavigateWhenSelectingCurrentMonthDay() throws {
        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 15
        )

        let day = CalendarDay(
            date: date,
            isCurrentMonth: true,
            isToday: false
        )

        let result = MonthCalendarLogic
            .shouldNavigateToAdjacentMonth(
                day: day,
                behavior: .navigate
            )

        #expect(!result)
    }

    @Test
    func normalizesHighlightedDatesToStartOfDay() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 17,
            hour: 18,
            minute: 30
        )

        let normalized = MonthCalendarLogic.normalizedDates(
            [date],
            calendar: calendar
        )

        let expected = try makeDate(
            year: 2026,
            month: 9,
            day: 17
        )

        #expect(normalized.contains(expected))
    }

    @Test
    func recognizesHighlightedDateRegardlessOfTime() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let storedDate = try makeDate(
            year: 2026,
            month: 9,
            day: 17,
            hour: 21
        )

        let calendarDate = try makeDate(
            year: 2026,
            month: 9,
            day: 17
        )

        let normalized = MonthCalendarLogic.normalizedDates(
            [storedDate],
            calendar: calendar
        )

        let result = MonthCalendarLogic.isHighlighted(
            calendarDate,
            highlightedDates: normalized,
            calendar: calendar
        )

        #expect(result)
    }

    @Test
    func weekdaySymbolsRespectSundayStart() {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.locale = Locale(
            identifier: "en_US"
        )

        calendar.firstWeekday = 1

        let symbols = MonthCalendarLogic.weekdaySymbols(
            calendar: calendar
        )

        #expect(symbols.count == 7)
        #expect(symbols.first == "Sun")
        #expect(symbols.last == "Sat")
    }

    @Test
    func weekdaySymbolsRespectMondayStart() {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.locale = Locale(
            identifier: "en_US"
        )

        calendar.firstWeekday = 2

        let symbols = MonthCalendarLogic.weekdaySymbols(
            calendar: calendar
        )

        #expect(symbols.count == 7)
        #expect(symbols.first == "Mon")
        #expect(symbols.last == "Sun")
    }
}
