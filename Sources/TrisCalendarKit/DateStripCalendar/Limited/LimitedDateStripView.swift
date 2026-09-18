//
//  LimitedDateStripView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-19.
//

import SwiftUI

struct LimitedDateStripView: View {
    private let pastDays: Int
    private let futureDays: Int

    private let configuration: CalendarConfiguration
    private let highlightedDates: Set<Date>
    private let style: CalendarStyle
    private let options: DateStripCalendarOptions

    private let onSelectDate: (Date) -> Void
    private let onDisplayedDateChange: (Date) -> Void

    @Binding private var selectedDate: Date?
    @Binding private var displayedDate: Date

    @State private var rangeAnchorDate: Date
    @State private var scrollReportedDate: Date?

    init(
        displayedDate: Binding<Date>,
        selectedDate: Binding<Date?>,
        highlightedDates: Set<Date>,
        configuration: CalendarConfiguration,
        style: CalendarStyle,
        options: DateStripCalendarOptions,
        pastDays: Int,
        futureDays: Int,
        onSelectDate: @escaping (Date) -> Void,
        onDisplayedDateChange: @escaping (Date) -> Void
    ) {
        self._displayedDate = displayedDate
        self._selectedDate = selectedDate

        self._rangeAnchorDate = State(
            initialValue: displayedDate.wrappedValue
        )

        self.highlightedDates = highlightedDates
        self.configuration = configuration
        self.style = style
        self.options = options

        self.pastDays = max(
            0,
            pastDays
        )

        self.futureDays = max(
            0,
            futureDays
        )

        self.onSelectDate = onSelectDate
        self.onDisplayedDateChange =
            onDisplayedDateChange
    }

    var body: some View {
        let calendar =
            configuration.configuredCalendar

        let generator = CalendarGenerator(
            configuration: configuration
        )

        let days = generator.makeDays(
            around: rangeAnchorDate,
            pastDays: pastDays,
            futureDays: futureDays
        )

        let normalizedHighlightedDates =
            CalendarDateUtility.normalize(
                highlightedDates,
                calendar: calendar
            )

        GeometryReader { geometry in
            let cellWidth =
                geometry.size.width
                / CGFloat(
                    options.visibleDayCount
                )

            ScrollViewReader { proxy in
                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    LazyHStack(spacing: 0) {
                        ForEach(days) { day in
                            Button {
                                selectedDate =
                                    day.date

                                onSelectDate(
                                    day.date
                                )
                            } label: {
                                DateStripDayCell(
                                    day: day,
                                    calendar: calendar,
                                    isSelected:
                                        isSelected(
                                            day.date,
                                            calendar:
                                                calendar
                                        ),
                                    isHighlighted:
                                        CalendarDateUtility.contains(
                                            day.date,
                                            in: normalizedHighlightedDates,
                                            calendar: calendar
                                        ),
                                    style: style
                                )
                                .frame(
                                    width: cellWidth
                                )
                                .background {
                                    GeometryReader {
                                        proxy in

                                        Color.clear
                                            .preference(
                                                key:
                                                    DateStripItemPositionPreferenceKey.self,
                                                value: [
                                                    DateStripItemPosition(
                                                        date:
                                                            day.date,
                                                        midX:
                                                            proxy.frame(
                                                                in: .named(
                                                                    "DateStripCalendarScrollView"
                                                                )
                                                            )
                                                            .midX
                                                    )
                                                ]
                                            )
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .id(
                                calendar.startOfDay(
                                    for: day.date
                                )
                            )
                        }
                    }
                }
                .coordinateSpace(
                    name:
                        "DateStripCalendarScrollView"
                )
                .onPreferenceChange(
                    DateStripItemPositionPreferenceKey.self
                ) { positions in
                    updateDisplayedDate(
                        from: positions,
                        containerWidth:
                            geometry.size.width,
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
                .onChange(
                    of: displayedDate
                ) { newDate in
                    if let scrollReportedDate,
                       calendar.isDate(
                           scrollReportedDate,
                           inSameDayAs: newDate
                       ) {
                        self.scrollReportedDate =
                            nil

                        return
                    }

                    if !contains(
                        newDate,
                        in: days,
                        calendar: calendar
                    ) {
                        rangeAnchorDate =
                            newDate

                        DispatchQueue.main.async {
                            proxy.scrollTo(
                                calendar.startOfDay(
                                    for: newDate
                                ),
                                anchor: .center
                            )
                        }

                        return
                    }

                    withAnimation {
                        proxy.scrollTo(
                            calendar.startOfDay(
                                for: newDate
                            ),
                            anchor: .center
                        )
                    }
                }
            }
        }
        .frame(
            height:
                style.dayCellSize + 30
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
        from positions:
            [DateStripItemPosition],
        containerWidth: CGFloat,
        calendar: Calendar
    ) {
        guard !positions.isEmpty else {
            return
        }

        let centerX =
            containerWidth / 2

        guard let closest =
            positions.min(
                by: {
                    abs(
                        $0.midX - centerX
                    )
                    <
                    abs(
                        $1.midX - centerX
                    )
                }
            )
        else {
            return
        }

        guard !calendar.isDate(
            displayedDate,
            inSameDayAs: closest.date
        ) else {
            return
        }

        scrollReportedDate =
            closest.date

        displayedDate =
            closest.date

        onDisplayedDateChange(
            closest.date
        )
    }

    private func contains(
        _ date: Date,
        in days: [CalendarDay],
        calendar: Calendar
    ) -> Bool {
        days.contains {
            calendar.isDate(
                $0.date,
                inSameDayAs: date
            )
        }
    }
}
