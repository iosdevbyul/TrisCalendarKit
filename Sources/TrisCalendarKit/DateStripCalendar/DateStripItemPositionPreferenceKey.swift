//
//  DateStripItemPositionPreferenceKey.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI

struct DateStripItemPositionPreferenceKey: PreferenceKey {
    static let defaultValue: [DateStripItemPosition] = []

    static func reduce(
        value: inout [DateStripItemPosition],
        nextValue: () -> [DateStripItemPosition]
    ) {
        value.append(contentsOf: nextValue())
    }
}
