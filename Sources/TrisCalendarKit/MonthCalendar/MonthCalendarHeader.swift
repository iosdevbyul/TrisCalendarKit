//
//  MonthCalendarHeader.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-15.
//

import SwiftUI

struct MonthCalendarHeader: View {
    let title: String
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void

    var body: some View {
        HStack {
            Button(action: onPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
            }

            Spacer()

            Text(title)
                .font(.system(size: 18, weight: .semibold))

            Spacer()

            Button(action: onNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .buttonStyle(.plain)
    }
}
