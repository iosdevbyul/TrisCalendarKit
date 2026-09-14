//
//  MonthWeekdayHeader.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-14.
//

import SwiftUI

struct MonthWeekdayHeader: View {
    let calendar: Calendar

    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols

        let firstWeekdayIndex = calendar.firstWeekday - 1

        return Array(
            symbols[firstWeekdayIndex...] +
            symbols[..<firstWeekdayIndex]
        )
    }
}
