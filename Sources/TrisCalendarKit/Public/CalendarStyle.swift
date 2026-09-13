//
//  CalendarStyle.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-14.
//

import SwiftUI

public struct CalendarStyle {
    public var selectedBackgroundColor: Color
    public var selectedTextColor: Color

    public var highlightedBackgroundColor: Color

    public var currentMonthTextColor: Color
    public var adjacentMonthTextColor: Color

    public var todayBorderColor: Color

    public init(
        selectedBackgroundColor: Color = .blue,
        selectedTextColor: Color = .white,
        highlightedBackgroundColor: Color = .blue.opacity(0.15),
        currentMonthTextColor: Color = .primary,
        adjacentMonthTextColor: Color = .secondary,
        todayBorderColor: Color = .blue
    ) {
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.highlightedBackgroundColor = highlightedBackgroundColor
        self.currentMonthTextColor = currentMonthTextColor
        self.adjacentMonthTextColor = adjacentMonthTextColor
        self.todayBorderColor = todayBorderColor
    }
}
