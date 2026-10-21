//
//  MonthWeekdayHeader.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-14.
//

import SwiftUI

struct MonthWeekdayHeader: View {
    let calendar: Calendar
    let style: CalendarStyle

    var body: some View {
        HStack(spacing: 0) {
            let symbols = MonthCalendarLogic.weekdaySymbols(calendar: calendar)
            ForEach(symbols.indices, id: \.self) { index in
                let dayOfWeek = ((calendar.firstWeekday - 1 + index) % 7) + 1
                Text(symbols[index])
                    .font(style.weekdayFont)
                    .foregroundColor(dayOfWeek == 1
                        ? (style.weekdaySundayColor ?? .secondary)
                        : dayOfWeek == 7
                            ? (style.weekdaySaturdayColor ?? .secondary)
                            : .secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
