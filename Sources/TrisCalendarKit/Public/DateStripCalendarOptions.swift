//
//  DateStripCalendarOptions.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

public struct DateStripCalendarOptions {
    public var pastDays: Int
    public var futureDays: Int
    public var visibleDayCount: Int

    public init(
        pastDays: Int = 365,
        futureDays: Int = 365,
        visibleDayCount: Int = 7
    ) {
        self.pastDays = max(0, pastDays)
        self.futureDays = max(0, futureDays)
        self.visibleDayCount = max(1, visibleDayCount)
    }
}
