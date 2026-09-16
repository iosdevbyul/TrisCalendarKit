//
//  InfiniteDateStripCalendarOptions.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

public struct InfiniteDateStripCalendarOptions {
    public var visibleDayCount: Int

    public init(
        visibleDayCount: Int = 7
    ) {
        self.visibleDayCount = max(
            1,
            visibleDayCount
        )
    }
}
