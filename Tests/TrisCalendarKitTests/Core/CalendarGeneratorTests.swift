import Foundation
import Testing

@testable import TrisCalendarKit

struct CalendarGeneratorTests {

    @Test
    func generatesFullMonthWithAdjacentDays() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 15
        )

        let expectedFirstDate = try makeDate(
            year: 2026,
            month: 8,
            day: 30
        )

        let expectedLastDate = try makeDate(
            year: 2026,
            month: 10,
            day: 3
        )

        let days = generator.makeMonthDays(
            for: date
        )

        #expect(days.count == 35)
        #expect(days.first?.date == expectedFirstDate)
        #expect(days.last?.date == expectedLastDate)
    }

    @Test
    func marksCurrentMonthCorrectly() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 15
        )

        let days = generator.makeMonthDays(
            for: date
        )

        let currentMonthDays = days.filter {
            $0.isCurrentMonth
        }

        #expect(currentMonthDays.count == 30)
    }

    @Test
    func supportsMondayAsFirstWeekday() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .monday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 15
        )

        let expectedFirstDate = try makeDate(
            year: 2026,
            month: 8,
            day: 31
        )

        let expectedLastDate = try makeDate(
            year: 2026,
            month: 10,
            day: 4
        )

        let days = generator.makeMonthDays(
            for: date
        )

        #expect(days.first?.date == expectedFirstDate)
        #expect(days.last?.date == expectedLastDate)
    }

    @Test
    func generatesLeapYearFebruaryCorrectly() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2024,
            month: 2,
            day: 10
        )

        let days = generator.makeMonthDays(
            for: date
        )

        let februaryDays = days.filter {
            $0.isCurrentMonth
        }

        #expect(februaryDays.count == 29)
    }

    @Test
    func handlesYearBoundary() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 12,
            day: 15
        )

        let days = generator.makeMonthDays(
            for: date
        )

        #expect(
            days.contains {
                Calendar(identifier: .gregorian)
                    .component(.year, from: $0.date) == 2027
            }
        )
    }
    
    @Test
    func generatesSevenDaysForSundayStart() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 15
        )

        let expectedFirstDate = try makeDate(
            year: 2026,
            month: 9,
            day: 13
        )

        let expectedLastDate = try makeDate(
            year: 2026,
            month: 9,
            day: 19
        )

        let days = generator.makeWeekDays(
            containing: date
        )

        #expect(days.count == 7)
        #expect(days.first?.date == expectedFirstDate)
        #expect(days.last?.date == expectedLastDate)
    }
    
    @Test
    func generatesSevenDaysForMondayStart() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .monday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 15
        )

        let expectedFirstDate = try makeDate(
            year: 2026,
            month: 9,
            day: 14
        )

        let expectedLastDate = try makeDate(
            year: 2026,
            month: 9,
            day: 20
        )

        let days = generator.makeWeekDays(
            containing: date
        )

        #expect(days.count == 7)
        #expect(days.first?.date == expectedFirstDate)
        #expect(days.last?.date == expectedLastDate)
    }
    
    @Test
    func generatesWeekAcrossMonthBoundary() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 9,
            day: 1
        )

        let expectedFirstDate = try makeDate(
            year: 2026,
            month: 8,
            day: 30
        )

        let expectedLastDate = try makeDate(
            year: 2026,
            month: 9,
            day: 5
        )

        let days = generator.makeWeekDays(
            containing: date
        )

        #expect(days.count == 7)
        #expect(days.first?.date == expectedFirstDate)
        #expect(days.last?.date == expectedLastDate)
    }
    
    @Test
    func generatesWeekAcrossYearBoundary() throws {
        let configuration = CalendarConfiguration(
            calendar: Calendar(identifier: .gregorian),
            locale: .unitedStates,
            timeZone: .custom(
                TimeZone(secondsFromGMT: 0)!
            ),
            weekStart: .sunday
        )

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let date = try makeDate(
            year: 2026,
            month: 12,
            day: 31
        )

        let expectedFirstDate = try makeDate(
            year: 2026,
            month: 12,
            day: 27
        )

        let expectedLastDate = try makeDate(
            year: 2027,
            month: 1,
            day: 2
        )

        let days = generator.makeWeekDays(
            containing: date
        )

        #expect(days.count == 7)
        #expect(days.first?.date == expectedFirstDate)
        #expect(days.last?.date == expectedLastDate)
    }
}
