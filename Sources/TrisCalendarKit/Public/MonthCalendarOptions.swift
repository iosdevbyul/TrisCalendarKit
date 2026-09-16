//
//  MonthCalendarOptions.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

public struct MonthCalendarOptions {
    public var showsNavigationButtons: Bool
    public var showsAdjacentMonthDates: Bool

    public init(
        showsNavigationButtons: Bool = true,
        showsAdjacentMonthDates: Bool = true
    ) {
        self.showsNavigationButtons = showsNavigationButtons
        self.showsAdjacentMonthDates = showsAdjacentMonthDates
    }
}
