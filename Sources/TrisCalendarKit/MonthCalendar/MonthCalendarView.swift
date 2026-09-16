//
//  MonthCalendarView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-13.
//

import SwiftUI

public struct MonthCalendarView: View {
    private let configuration: CalendarConfiguration
    private let highlightedDates: Set<Date>
    private let onSelectDate: (Date) -> Void

    @Binding private var selectedDate: Date?
    @Binding private var displayedMonth: Date
    
    private let style: CalendarStyle
    private let adjacentMonthSelectionBehavior: AdjacentMonthSelectionBehavior
    private let onDisplayedMonthChange: (Date) -> Void
    private let options: MonthCalendarOptions
    
    public init(
        displayedMonth: Binding<Date>,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        options: MonthCalendarOptions = MonthCalendarOptions(),
        adjacentMonthSelectionBehavior: AdjacentMonthSelectionBehavior = .navigate,
        onSelectDate: @escaping (Date) -> Void = { _ in },
        onDisplayedMonthChange: @escaping (Date) -> Void = { _ in }
    ) {
        self._displayedMonth = displayedMonth
        self._selectedDate = selectedDate
        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
        self.options = options
        self.adjacentMonthSelectionBehavior = adjacentMonthSelectionBehavior
        self.onSelectDate = onSelectDate
        self.onDisplayedMonthChange = onDisplayedMonthChange
    }

    public var body: some View {
        let calendar = configuration.configuredCalendar

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let days = generator.makeMonthDays(
            for: displayedMonth
        )
        
        let normalizedHighlightedDates = MonthCalendarLogic.normalizedDates(
            highlightedDates,
            calendar: calendar
        )

        VStack(spacing: style.sectionSpacing) {
            MonthCalendarHeader(
                title: monthTitle(
                    for: displayedMonth,
                    calendar: calendar
                ),
                style: style,
                showsNavigationButtons: options.showsNavigationButtons,
                onPreviousMonth: {
                    moveMonth(
                        by: -1,
                        calendar: calendar
                    )
                },
                onNextMonth: {
                    moveMonth(
                        by: 1,
                        calendar: calendar
                    )
                }
            )

            MonthWeekdayHeader(
                calendar: calendar,
                style: style
            )

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(
                        .flexible(),
                        spacing: 0
                    ),
                    count: 7
                ),
                spacing: style.dayRowSpacing
            ) {
                ForEach(days) { day in
                    if day.isCurrentMonth || options.showsAdjacentMonthDates {
                        Button {
                            select(day)
                        } label: {
                            MonthDayCell(
                                day: day,
                                calendar: calendar,
                                isSelected: isSelected(
                                    day.date,
                                    calendar: calendar
                                ),
                                isHighlighted: MonthCalendarLogic.isHighlighted(
                                    day.date,
                                    highlightedDates: normalizedHighlightedDates,
                                    calendar: calendar
                                ),
                                style: style
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear
                            .frame(
                                width: style.dayCellSize,
                                height: style.dayCellSize
                            )
                    }
                }
            }
        }
    }

    private func isSelected(
        _ date: Date,
        calendar: Calendar
    ) -> Bool {
        guard let selectedDate else {
            return false
        }

        return calendar.isDate(
            date,
            inSameDayAs: selectedDate
        )
    }

    private func isHighlighted(
        _ date: Date,
        calendar: Calendar,
        highlightedDates: Set<Date>
    ) -> Bool {
        highlightedDates.contains(
            calendar.startOfDay(for: date)
        )
    }
    
    private func moveMonth(
        by value: Int,
        calendar: Calendar
    ) {
        guard let newMonth = calendar.date(
            byAdding: .month,
            value: value,
            to: displayedMonth
        ) else {
            return
        }

        displayedMonth = newMonth
        onDisplayedMonthChange(newMonth)
    }

    private func monthTitle(
        for date: Date,
        calendar: Calendar
    ) -> String {
        let formatter = DateFormatter()

        formatter.calendar = calendar
        formatter.locale = configuration.locale.locale
        formatter.timeZone = configuration.timeZone.timeZone
        formatter.setLocalizedDateFormatFromTemplate("yyyyMMMM")

        return formatter.string(from: date)
    }

    private func select(
        _ day: CalendarDay
    ) {
        selectedDate = day.date
        onSelectDate(day.date)

        guard MonthCalendarLogic.shouldNavigateToAdjacentMonth(
            day: day,
            behavior: adjacentMonthSelectionBehavior
        ) else {
            return
        }

        displayedMonth = day.date
        onDisplayedMonthChange(day.date)
    }
}
