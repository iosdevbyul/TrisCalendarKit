//
//  InfiniteDateStripCalendarView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI

public struct InfiniteDateStripCalendarView: View {
    private let highlightedDates: Set<Date>
    private let configuration: CalendarConfiguration
    private let style: CalendarStyle
    private let options: InfiniteDateStripCalendarOptions

    private let onSelectDate: (Date) -> Void
    private let onDisplayedDateChange: (Date) -> Void

    @Binding private var displayedDate: Date
    @Binding private var selectedDate: Date?

    public init(
        displayedDate: Binding<Date>,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date> = [],
        configuration: CalendarConfiguration = CalendarConfiguration(),
        style: CalendarStyle = CalendarStyle(),
        options: InfiniteDateStripCalendarOptions = InfiniteDateStripCalendarOptions(),
        onSelectDate: @escaping (Date) -> Void = { _ in },
        onDisplayedDateChange: @escaping (Date) -> Void = { _ in }
    ) {
        self._displayedDate = displayedDate
        self._selectedDate = selectedDate
        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
        self.options = options
        self.onSelectDate = onSelectDate
        self.onDisplayedDateChange = onDisplayedDateChange
    }

    public var body: some View {
        InfiniteDateStripScrollView(
            displayedDate: $displayedDate,
            selectedDate: $selectedDate,
            highlightedDates: highlightedDates,
            configuration: configuration,
            style: style,
            options: options,
            onSelectDate: onSelectDate,
            onDisplayedDateChange: onDisplayedDateChange
        )
    }
}
