//
//  CalendarLocale.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-13.
//

import Foundation

public enum CalendarLocale {
    case system

    case korea
    case unitedStates
    case japan
    case unitedKingdom

    case custom(Locale)

    var locale: Locale {
        switch self {
        case .system:
            return .current

        case .korea:
            return Locale(identifier: "ko_KR")

        case .unitedStates:
            return Locale(identifier: "en_US")

        case .japan:
            return Locale(identifier: "ja_JP")

        case .unitedKingdom:
            return Locale(identifier: "en_GB")

        case .custom(let locale):
            return locale
        }
    }
}
