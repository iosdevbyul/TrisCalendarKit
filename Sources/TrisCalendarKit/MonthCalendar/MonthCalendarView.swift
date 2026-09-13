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

    private let displayedMonth: Date
    private let style: CalendarStyle
    
    public init(
        displayedMonth: Date,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        onSelectDate: @escaping (Date) -> Void = { _ in }
    ) {
        self.displayedMonth = displayedMonth
        self._selectedDate = selectedDate
        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
        self.onSelectDate = onSelectDate
    }

    public var body: some View {
        let calendar = configuration.configuredCalendar
        let generator = CalendarGenerator(
            configuration: configuration
        )

        let days = generator.makeMonthDays(
            for: displayedMonth
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
                    selectedDate = day.date
                    onSelectDate(day.date)
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
}
