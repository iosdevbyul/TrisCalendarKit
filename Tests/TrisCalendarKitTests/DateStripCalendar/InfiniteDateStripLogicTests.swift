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
}
