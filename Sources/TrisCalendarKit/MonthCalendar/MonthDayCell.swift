//
//  MonthDayCell.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-13.
//

import SwiftUI

struct MonthDayCell: View {
    let day: CalendarDay
    let calendar: Calendar
    let isSelected: Bool
    let isHighlighted: Bool
    let style: CalendarStyle

    var body: some View {
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

        if day.isCurrentMonth {
            return style.currentMonthTextColor
        }

        return style.adjacentMonthTextColor
    }
}
