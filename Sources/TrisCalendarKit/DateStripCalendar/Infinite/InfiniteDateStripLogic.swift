//
//  InfiniteDateStripLogic.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import Foundation

struct InfiniteDateStripLogic {
    let itemCount: Int
    let centerIndex: Int
    let recenterThreshold: Int

    init(
        itemCount: Int = 1001,
        centerIndex: Int = 500,
        recenterThreshold: Int = 150
    ) {
        self.itemCount = itemCount
        self.centerIndex = centerIndex
        self.recenterThreshold = recenterThreshold
    }

    func offset(
        for index: Int
    ) -> Int {
        index - centerIndex
    }

    func date(
        for index: Int,
        anchorDate: Date,
        calendar: Calendar
    ) -> Date? {
        calendar.date(
            byAdding: .day,
            value: offset(for: index),
            to: anchorDate
        )
    }

    func shouldRecenter(
        at index: Int
    ) -> Bool {
        index <= recenterThreshold
            || index >= itemCount - recenterThreshold
    }
}
