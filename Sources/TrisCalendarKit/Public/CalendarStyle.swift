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

    public var dayFont: Font
    public var weekdayFont: Font
    public var headerFont: Font

    public var dayCellSize: CGFloat
    public var dayRowSpacing: CGFloat
    public var sectionSpacing: CGFloat

    public init(
        selectedBackgroundColor: Color = .blue,
        selectedTextColor: Color = .white,
        highlightedBackgroundColor: Color = .blue.opacity(0.15),
        currentMonthTextColor: Color = .primary,
        adjacentMonthTextColor: Color = .secondary,
        todayBorderColor: Color = .blue,
        dayFont: Font = .system(size: 14, weight: .medium),
        weekdayFont: Font = .system(size: 12, weight: .medium),
        headerFont: Font = .system(size: 18, weight: .semibold),
        dayCellSize: CGFloat = 36,
        dayRowSpacing: CGFloat = 8,
        sectionSpacing: CGFloat = 12
    ) {
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.highlightedBackgroundColor = highlightedBackgroundColor
        self.currentMonthTextColor = currentMonthTextColor
        self.adjacentMonthTextColor = adjacentMonthTextColor
        self.todayBorderColor = todayBorderColor
        self.dayFont = dayFont
        self.weekdayFont = weekdayFont
        self.headerFont = headerFont
        self.dayCellSize = dayCellSize
        self.dayRowSpacing = dayRowSpacing
        self.sectionSpacing = sectionSpacing
    }
}
