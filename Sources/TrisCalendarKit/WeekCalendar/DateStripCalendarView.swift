//
//  DateStripCalendarView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI

public struct DateStripCalendarView: View {
    private let configuration: CalendarConfiguration
    private let highlightedDates: Set<Date>
    private let style: CalendarStyle
    private let onSelectDate: (Date) -> Void
    private let onDisplayedWeekChange: (Date) -> Void

    @Binding private var selectedDate: Date?
    @Binding private var displayedDate: Date

    public init(
        displayedDate: Binding<Date>,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        onSelectDate: @escaping (Date) -> Void = { _ in },
        onDisplayedWeekChange: @escaping (Date) -> Void = { _ in }
    ) {
        self._displayedDate = displayedDate
        self._selectedDate = selectedDate
        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
        self.onSelectDate = onSelectDate
        self.onDisplayedWeekChange = onDisplayedWeekChange
    }

    public var body: some View {
        let calendar = configuration.configuredCalendar

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let days = generator.makeWeekDays(
            containing: displayedDate
        )

        let normalizedHighlightedDates = Set(
            highlightedDates.map {
                calendar.startOfDay(for: $0)
            }
        )

        HStack(spacing: 0) {
            ForEach(days) { day in
                Button {
                    selectedDate = day.date
                    onSelectDate(day.date)
                } label: {
                    DateStripDayCell(
                        day: day,
                        calendar: calendar,
                        isSelected: isSelected(
                            day.date,
                            calendar: calendar
                        ),
                        isHighlighted: normalizedHighlightedDates.contains(
                            calendar.startOfDay(for: day.date)
                        ),
                        style: style
                    )
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
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
}
