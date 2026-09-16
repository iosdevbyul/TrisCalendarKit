//
//  DateStripDayCell.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI

struct DateStripDayCell: View {
    let day: CalendarDay
    let calendar: Calendar
    let isSelected: Bool
    let isHighlighted: Bool
    let style: CalendarStyle

    var body: some View {
        VStack(spacing: 6) {
            Text(weekdayText)
                .font(style.weekdayFont)
                .foregroundColor(.secondary)

            ZStack {
                Circle()
                    .fill(backgroundColor)

                if day.isToday && !isSelected {
                    Circle()
                        .stroke(
                            style.todayBorderColor,
                            lineWidth: 1
                        )
                }

                Text(dayText)
                    .font(style.dayFont)
                    .foregroundColor(textColor)
            }
            .frame(
                width: style.dayCellSize,
                height: style.dayCellSize
            )
        }
    }

    private var weekdayText: String {
        let weekday = calendar.component(
            .weekday,
            from: day.date
        )

        return calendar.shortStandaloneWeekdaySymbols[
            weekday - 1
        ]
    }

    private var dayText: String {
        String(
            calendar.component(
                .day,
                from: day.date
            )
        )
    }

    private var backgroundColor: Color {
        if isSelected {
            return style.selectedBackgroundColor
        }

        if isHighlighted {
            return style.highlightedBackgroundColor
        }

        return .clear
    }

    private var textColor: Color {
        if isSelected {
            return style.selectedTextColor
        }

        return style.currentMonthTextColor
    }
}
