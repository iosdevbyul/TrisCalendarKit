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
    private let options: DateStripCalendarOptions
    private let onSelectDate: (Date) -> Void

    @Binding private var selectedDate: Date?
    @Binding private var displayedDate: Date

    public init(
        displayedDate: Binding<Date>,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        options: DateStripCalendarOptions = DateStripCalendarOptions(),
        onSelectDate: @escaping (Date) -> Void = { _ in }
    ) {
        self._displayedDate = displayedDate
        self._selectedDate = selectedDate
        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
        self.options = options
        self.onSelectDate = onSelectDate
    }

    public var body: some View {
        let calendar = configuration.configuredCalendar

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let days = generator.makeDays(
            around: displayedDate,
            pastDays: options.pastDays,
            futureDays: options.futureDays
        )

        let normalizedHighlightedDates = Set(
            highlightedDates.map {
                calendar.startOfDay(for: $0)
            }
        )

        GeometryReader { geometry in
            let cellWidth =
                geometry.size.width /
                CGFloat(options.visibleDayCount)

            ScrollViewReader { proxy in
                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    LazyHStack(spacing: 0) {
                        ForEach(days) { day in
                            Button {
                                selectedDate = day.date
                                displayedDate = day.date
                                onSelectDate(day.date)
                            } label: {
                                DateStripDayCell(
                                    day: day,
                                    calendar: calendar,
                                    isSelected: isSelected(
                                        day.date,
                                        calendar: calendar
                                    ),
                                    isHighlighted:
                                        normalizedHighlightedDates.contains(
                                            calendar.startOfDay(
                                                for: day.date
                                            )
                                        ),
                                    style: style
                                )
                                .frame(width: cellWidth)
                            }
                            .buttonStyle(.plain)
                            .id(
                                calendar.startOfDay(
                                    for: day.date
                                )
                            )
                        }//:ForEach
                    }//:LazyHStack
                }
                .coordinateSpace(
                    name: "DateStripCalendarScrollView"
                )
                .onPreferenceChange(
                    DateStripItemPositionPreferenceKey.self
                ) { positions in
                    updateDisplayedDate(
                        from: positions,
                        containerWidth: geometry.size.width,
                        calendar: calendar
                    )
                }
                .onAppear {
                    proxy.scrollTo(
                        calendar.startOfDay(
                            for: displayedDate
                        ),
                        anchor: .center
                    )
                }
            }//:ScrollViewReader
        }
        .frame(
            height: style.dayCellSize + 30
        )
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
    
    private func updateDisplayedDate(
        from positions: [DateStripItemPosition],
        containerWidth: CGFloat,
        calendar: Calendar
    ) {
        guard !positions.isEmpty else {
            return
        }

        let centerX = containerWidth / 2

        guard let closest = positions.min(
            by: {
                abs($0.midX - centerX) <
                abs($1.midX - centerX)
            }
        ) else {
            return
        }

        guard !calendar.isDate(
            displayedDate,
            inSameDayAs: closest.date
        ) else {
            return
        }

        displayedDate = closest.date
    }
}
