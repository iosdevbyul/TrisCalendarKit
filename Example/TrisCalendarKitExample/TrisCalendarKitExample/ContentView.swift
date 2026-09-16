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
    @State private var selectedDate: Date?
    
    @State private var displayedWeekDate = Date()
    @State private var selectedWeekDate: Date?

    var body: some View {
        MonthCalendarView(
            displayedMonth: $displayedMonth,
            selectedDate: $selectedDate,
            highlightedDates: highlightedDates,
            configuration: CalendarConfiguration(
                locale: .korea,
                timeZone: .seoul,
                weekStart: .sunday
            ),
            onSelectDate: { date in
                print("Selected:", date)
            },
            onDisplayedMonthChange: { month in
                print("Month changed:", month)
            }
        )
        .padding()
        
        
        DateStripCalendarView(
            displayedDate: $displayedWeekDate,
            selectedDate: $selectedWeekDate,
            highlightedDates: highlightedDates,
            configuration: CalendarConfiguration(
                locale: .korea,
                timeZone: .seoul,
                weekStart: .sunday
            ),
            onSelectDate: { date in
                print("Selected week date:", date)
            }
        )
        .padding()
        
        Button("Today") {
            displayedMonth = Date()
            selectedDate = Date()
        }
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
