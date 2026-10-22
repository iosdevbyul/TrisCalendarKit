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
    let isOutlined: Bool
    let style: CalendarStyle
    let dateTextColor: Color?
    let dateLabel: String?
    let showsDateLabels: Bool

    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(backgroundColor)

                if isOutlined && !isSelected {
                    Circle()
                        .stroke(style.selectedBackgroundColor, lineWidth: 1.5)
                }

                if day.isToday && !isSelected && !isOutlined {
                    Circle()
                        .stroke(style.todayBorderColor, lineWidth: 1)
                }

                Text(dayText)
                    .font(style.dayFont)
                    .foregroundColor(textColor)
            }
            .frame(width: style.dayCellSize, height: style.dayCellSize)

            if showsDateLabels {
                Text(dateLabel ?? " ")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(dateTextColor ?? .secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 27)
                    .accessibilityHidden(dateLabel == nil)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: showsDateLabels ? style.dayCellSize + 30 : style.dayCellSize)
        .accessibilityElement(children: .combine)
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
            return dateTextColor ?? style.currentMonthTextColor
        }

        return style.adjacentMonthTextColor
    }
}
