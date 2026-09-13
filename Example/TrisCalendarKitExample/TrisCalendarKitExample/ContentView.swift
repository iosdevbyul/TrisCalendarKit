//
//  ContentView.swift
//  TrisCalendarKitExample
//
//  Created by COMATOKI on 2026-09-14.
//

import SwiftUI
import TrisCalendarKit

struct ContentView: View {
    @State private var selectedDate: Date?

    var body: some View {
        MonthCalendarView(
            displayedMonth: Date(),
            selectedDate: $selectedDate,
            highlightedDates: highlightedDates,
            configuration: CalendarConfiguration(
                locale: .korea,
                timeZone: .seoul,
                weekStart: .sunday
            ),
            onSelectDate: { date in
                print("Selected date:", date)
            }
        )
        .padding()
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
