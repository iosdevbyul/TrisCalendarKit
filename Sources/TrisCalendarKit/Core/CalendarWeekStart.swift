//
//  CalendarWeekStart.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-13.
//

import Foundation

public enum CalendarWeekStart {
    case system
    case sunday
    case monday

    var firstWeekday: Int? {
        switch self {
        case .system:
            return nil

        case .sunday:
            return 1

        case .monday:
            return 2
        }
    }
}
