//
//  InfiniteDateStripLogicTests.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import Foundation
import Testing

@testable import TrisCalendarKit

struct InfiniteDateStripLogicTests {

    @Test
    func centerIndexHasZeroOffset() {
        let logic = InfiniteDateStripLogic()

        #expect(
            logic.offset(for: logic.centerIndex) == 0
        )
    }

    @Test
    func calculatesPositiveOffset() {
        let logic = InfiniteDateStripLogic()

        #expect(
            logic.offset(
                for: logic.centerIndex + 10
            ) == 10
        )
    }

    @Test
    func calculatesNegativeOffset() {
        let logic = InfiniteDateStripLogic()

        #expect(
            logic.offset(
                for: logic.centerIndex - 10
            ) == -10
        )
    }

    @Test
    func generatesDateFromIndexOffset() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let logic = InfiniteDateStripLogic()

        let anchorDate = try makeDate(
            year: 2026,
            month: 9,
            day: 17
        )

        let expectedDate = try makeDate(
            year: 2026,
            month: 9,
            day: 27
        )

        let result = logic.date(
            for: logic.centerIndex + 10,
            anchorDate: anchorDate,
            calendar: calendar
        )

        #expect(result == expectedDate)
    }

    @Test
    func recentersNearBeginning() {
        let logic = InfiniteDateStripLogic()

        #expect(
            logic.shouldRecenter(
                at: 100
            )
        )
    }

    @Test
    func recentersNearEnd() {
        let logic = InfiniteDateStripLogic()

        #expect(
            logic.shouldRecenter(
                at: 900
            )
        )
    }

    @Test
    func doesNotRecenterNearCenter() {
        let logic = InfiniteDateStripLogic()

        #expect(
            !logic.shouldRecenter(
                at: logic.centerIndex
            )
        )
    }

    @Test
    func thresholdBoundaryTriggersRecenter() {
        let logic = InfiniteDateStripLogic()

        #expect(
            logic.shouldRecenter(
                at: logic.recenterThreshold
            )
        )

        #expect(
            logic.shouldRecenter(
                at:
                    logic.itemCount
                    - logic.recenterThreshold
            )
        )
    }
    
    @Test
    func generatesDateAcrossMonthBoundary() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let logic = InfiniteDateStripLogic()

        let anchorDate = try makeDate(
            year: 2026,
            month: 9,
            day: 30
        )

        let expectedDate = try makeDate(
            year: 2026,
            month: 10,
            day: 2
        )

        let result = logic.date(
            for: logic.centerIndex + 2,
            anchorDate: anchorDate,
            calendar: calendar
        )

        #expect(result == expectedDate)
    }
    
    @Test
    func generatesDateAcrossYearBoundary() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let logic = InfiniteDateStripLogic()

        let anchorDate = try makeDate(
            year: 2026,
            month: 12,
            day: 31
        )

        let expectedDate = try makeDate(
            year: 2027,
            month: 1,
            day: 3
        )

        let result = logic.date(
            for: logic.centerIndex + 3,
            anchorDate: anchorDate,
            calendar: calendar
        )

        #expect(result == expectedDate)
    }
    
    @Test
    func generatesPastDateFromNegativeOffset() throws {
        var calendar = Calendar(
            identifier: .gregorian
        )

        calendar.timeZone = TimeZone(
            secondsFromGMT: 0
        )!

        let logic = InfiniteDateStripLogic()

        let anchorDate = try makeDate(
            year: 2026,
            month: 1,
            day: 2
        )

        let expectedDate = try makeDate(
            year: 2025,
            month: 12,
            day: 30
        )

        let result = logic.date(
            for: logic.centerIndex - 3,
            anchorDate: anchorDate,
            calendar: calendar
        )

        #expect(result == expectedDate)
    }
    
    @Test
    func doesNotRecenterInsideSafeRange() {
        let logic = InfiniteDateStripLogic()

        #expect(
            !logic.shouldRecenter(
                at: logic.recenterThreshold + 1
            )
        )

        #expect(
            !logic.shouldRecenter(
                at:
                    logic.itemCount
                    - logic.recenterThreshold
                    - 1
            )
        )
    }
}
