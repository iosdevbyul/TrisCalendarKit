//
//  ContentView.swift
//  TrisCalendarKitExample
//
//  Created by COMATOKI on 2026-09-14.
//

import SwiftUI
import TrisCalendarKit

struct ContentView: View {
    @State private var displayedMonth = Date()
    @State private var selectedMonthDate: Date?

    @State private var displayedLimitedDate = Date()
    @State private var selectedLimitedDate: Date?

    @State private var displayedInfiniteDate = Date()
    @State private var selectedInfiniteDate: Date?

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                monthCalendarSection

                limitedDateStripSection

                infiniteDateStripSection
            }
            .padding()
        }
    }

    private var monthCalendarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Month Calendar")
                .font(.headline)

            MonthCalendarView(
                displayedMonth: $displayedMonth,
                selectedDate: $selectedMonthDate,
                highlightedDates: highlightedDates,
                configuration: calendarConfiguration,
                onSelectDate: { date in
                    print(
                        "Month selected:",
                        date
                    )
                },
                onDisplayedMonthChange: { date in
                    print(
                        "Month changed:",
                        date
                    )
                }
            )

            Button("Today") {
                displayedMonth = Date()
                selectedMonthDate = Date()
            }
        }
    }

    private var limitedDateStripSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Limited Date Strip")
                .font(.headline)

            DateStripCalendarView(
                displayedDate: $displayedLimitedDate,
                selectedDate: $selectedLimitedDate,
                range: .limited(
                    pastDays: 30,
                    futureDays: 30
                ),
                highlightedDates: highlightedDates,
                configuration: calendarConfiguration,
                onSelectDate: { date in
                    print(
                        "Limited selected:",
                        date
                    )
                },
                onDisplayedDateChange: { date in
                    print(
                        "Limited displayed:",
                        date
                    )
                }
            )

            Button("Today") {
                displayedLimitedDate = Date()
                selectedLimitedDate = Date()
            }
        }
    }

    private var infiniteDateStripSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Infinite Date Strip")
                .font(.headline)

            DateStripCalendarView(
                displayedDate: $displayedInfiniteDate,
                selectedDate: $selectedInfiniteDate,
                range: .infinite,
                highlightedDates: highlightedDates,
                configuration: calendarConfiguration,
                onSelectDate: { date in
                    print(
                        "Infinite selected:",
                        date
                    )
                },
                onDisplayedDateChange: { date in
                    print(
                        "Infinite displayed:",
                        date
                    )
                }
            )

            Button("Today") {
                displayedInfiniteDate = Date()
                selectedInfiniteDate = Date()
            }
        }
    }

    private var calendarConfiguration: CalendarConfiguration {
        CalendarConfiguration(
            locale: .korea,
            timeZone: .seoul,
            weekStart: .sunday
        )
    }

    private var highlightedDates: Set<Date> {
        let calendar = Calendar.current

        return Set(
            [
                calendar.date(
                    byAdding: .day,
                    value: -2,
                    to: Date()
                ),
                calendar.date(
                    byAdding: .day,
                    value: -5,
                    to: Date()
                )
            ]
            .compactMap { $0 }
        )
    }
}

#Preview {
    ContentView()
}
