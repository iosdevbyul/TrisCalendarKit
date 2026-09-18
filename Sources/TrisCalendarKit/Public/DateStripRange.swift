//
//  DateStripRange.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-19.
//

public enum DateStripRange {
    case limited(
        pastDays: Int,
        futureDays: Int
    )

    case infinite
}
