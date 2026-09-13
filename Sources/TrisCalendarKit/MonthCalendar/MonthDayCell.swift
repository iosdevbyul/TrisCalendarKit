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

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            Text(dayText)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
        }
        .frame(width: 36, height: 36)
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
            return .blue
        }

        if isHighlighted {
            return .green.opacity(0.2)
        }

        return .clear
    }

    private var textColor: Color {
        if isSelected {
            return .white
        }

        if day.isCurrentMonth {
            return .primary
        }

        return .secondary
    }
}
