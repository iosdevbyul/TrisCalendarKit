//
//  DateStripCalendarView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI

public struct DateStripCalendarView: View {
    private let range: DateStripRange

    private let highlightedDates: Set<Date>
    private let configuration: CalendarConfiguration
    private let style: CalendarStyle
    private let options: DateStripCalendarOptions

    private let onSelectDate: (Date) -> Void
    private let onDisplayedDateChange: (Date) -> Void

    @Binding private var displayedDate: Date
    @Binding private var selectedDate: Date?

    public init(
        displayedDate: Binding<Date>,
        selectedDate: Binding<Date?>,
        range: DateStripRange = .infinite,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        options: DateStripCalendarOptions = DateStripCalendarOptions(),
        onSelectDate: @escaping (Date) -> Void = { _ in },
        onDisplayedDateChange: @escaping (Date) -> Void = { _ in }
    ) {
        self._displayedDate =
            displayedDate

        self._selectedDate =
            selectedDate

        self.range = range
        self.highlightedDates =
            highlightedDates
        self.configuration =
            configuration
        self.style = style
        self.options = options

        self.onSelectDate =
            onSelectDate

        self.onDisplayedDateChange =
            onDisplayedDateChange
    }

    public var body: some View {
        switch range {

        case .limited(
            let pastDays,
            let futureDays
        ):
            LimitedDateStripView(
                displayedDate:
                    $displayedDate,
                selectedDate:
                    $selectedDate,
                highlightedDates:
                    highlightedDates,
                configuration:
                    configuration,
                style:
                    style,
                options:
                    options,
                pastDays:
                    pastDays,
                futureDays:
                    futureDays,
                onSelectDate:
                    onSelectDate,
                onDisplayedDateChange:
                    onDisplayedDateChange
            )

        case .infinite:
            InfiniteDateStripScrollView(
                displayedDate:
                    $displayedDate,
                selectedDate:
                    $selectedDate,
                highlightedDates:
                    highlightedDates,
                configuration:
                    configuration,
                style:
                    style,
                options:
                    options,
                onSelectDate:
                    onSelectDate,
                onDisplayedDateChange:
                    onDisplayedDateChange
            )
        }
    }
}
