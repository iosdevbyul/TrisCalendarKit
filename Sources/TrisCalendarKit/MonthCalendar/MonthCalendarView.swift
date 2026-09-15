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

    @State private var displayedMonth: Date
    private let style: CalendarStyle
    private let adjacentMonthSelectionBehavior: AdjacentMonthSelectionBehavior
    private let onDisplayedMonthChange: (Date) -> Void
    
    public init(
        displayedMonth: Date,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        adjacentMonthSelectionBehavior: AdjacentMonthSelectionBehavior = .navigate,
        onSelectDate: @escaping (Date) -> Void = { _ in },
        onDisplayedMonthChange: @escaping (Date) -> Void = { _ in }
    ) {
        self._displayedMonth = State(
            initialValue: displayedMonth
        )
        self._selectedDate = selectedDate
        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
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

        VStack(spacing: 12) {
            MonthCalendarHeader(
                title: monthTitle(
                    for: displayedMonth,
                    calendar: calendar
                ),
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
                calendar: calendar
            )

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(
                        .flexible(),
                        spacing: 0
                    ),
                    count: 7
                ),
                spacing: 8
            ) {
                ForEach(days) { day in
                    Button {
                        select(
                            day,
                            calendar: calendar
                        )
                    } label: {
                        MonthDayCell(
                            day: day,
                            calendar: calendar,
                            isSelected: isSelected(
                                day.date,
                                calendar: calendar
                            ),
                            isHighlighted: isHighlighted(
                                day.date,
                                calendar: calendar
                            ),
                            style: style
                        )
                    }
                    .buttonStyle(.plain)
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
        calendar: Calendar
    ) -> Bool {
        highlightedDates.contains {
            calendar.isDate(
                $0,
                inSameDayAs: date
            )
        }
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
        _ day: CalendarDay,
        calendar: Calendar
    ) {
        selectedDate = day.date
        onSelectDate(day.date)

        guard
            !day.isCurrentMonth,
            adjacentMonthSelectionBehavior == .navigate
        else {
            return
        }

        displayedMonth = day.date
        onDisplayedMonthChange(day.date)
    }
}

