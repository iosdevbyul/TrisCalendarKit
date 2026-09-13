//
//  CalendarTimeZone.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-13.
//

import Foundation

public enum CalendarTimeZone {
    case system

    case seoul
    case losAngeles
    case newYork
    case london
    case tokyo

    case custom(TimeZone)

    var timeZone: TimeZone {
        switch self {
        case .system:
            return .current

        case .seoul:
            return TimeZone(identifier: "Asia/Seoul") ?? .current

        case .losAngeles:
            return TimeZone(identifier: "America/Los_Angeles") ?? .current

        case .newYork:
            return TimeZone(identifier: "America/New_York") ?? .current

        case .london:
            return TimeZone(identifier: "Europe/London") ?? .current

        case .tokyo:
            return TimeZone(identifier: "Asia/Tokyo") ?? .current

        case .custom(let timeZone):
            return timeZone
        }
    }
}
