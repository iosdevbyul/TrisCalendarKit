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
    
    @State private var displayedInfiniteDate = Date()
    @State private var selectedInfiniteDate: Date?

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
                print("DateStrip selected:", date)
            },
            onDisplayedDateChange: { date in
                print("DateStrip displayed:", date)
            }
        )
        .padding()
        
        InfiniteDateStripCalendarView(
            displayedDate: $displayedInfiniteDate,
            selectedDate: $selectedInfiniteDate,
            highlightedDates: highlightedDates,
            configuration: CalendarConfiguration(
                locale: .korea,
                timeZone: .seoul,
                weekStart: .sunday
            ),
            onSelectDate: { date in
                print("Infinite selected:", date)
            },
            onDisplayedDateChange: { date in
                print("Infinite displayed:", date)
            }
        )
        .frame(height: 80)
        .padding()
        
        Button("Infinite Today") {
            displayedInfiniteDate = Date()
        }
        
        Button("Go to 2035") {
            var components = DateComponents()
            components.year = 2035
            components.month = 5
            components.day = 10

            displayedInfiniteDate =
                Calendar.current.date(
                    from: components
                ) ?? Date()
        }
        
        Button("Today") {
            displayedMonth = Date()
            selectedDate = Date()

            displayedWeekDate = Date()
            selectedWeekDate = Date()
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
