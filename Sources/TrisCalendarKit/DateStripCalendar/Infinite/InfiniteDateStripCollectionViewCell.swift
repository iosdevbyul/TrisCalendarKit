//
//  InfiniteDateStripCollectionViewCell.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI
import UIKit

@MainActor
final class InfiniteDateStripCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "InfiniteDateStripCollectionViewCell"

    private var hostingController:
        UIHostingController<DateStripDayCell>?

    override init(
        frame: CGRect
    ) {
        super.init(frame: frame)
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(
        date: Date,
        calendar: Calendar,
        selectedDate: Date?,
        isHighlighted: Bool,
        style: CalendarStyle
    ) {
        let day = CalendarDay(
            date: date,
            isCurrentMonth: true,
            isToday: calendar.isDateInToday(date)
        )

        let isSelected: Bool

        if let selectedDate {
            isSelected = calendar.isDate(
                date,
                inSameDayAs: selectedDate
            )
        } else {
            isSelected = false
        }

        let rootView = DateStripDayCell(
            day: day,
            calendar: calendar,
            isSelected: isSelected,
            isHighlighted: isHighlighted,
            style: style
        )

        if let hostingController {
            hostingController.rootView = rootView
            return
        }

        let hostingController =
            UIHostingController(
                rootView: rootView
            )

        hostingController.view.backgroundColor =
            .clear

        hostingController.view
            .translatesAutoresizingMaskIntoConstraints =
            false

        contentView.addSubview(
            hostingController.view
        )

        NSLayoutConstraint.activate([
            hostingController.view
                .leadingAnchor
                .constraint(
                    equalTo:
                        contentView.leadingAnchor
                ),

            hostingController.view
                .trailingAnchor
                .constraint(
                    equalTo:
                        contentView.trailingAnchor
                ),

            hostingController.view
                .topAnchor
                .constraint(
                    equalTo:
                        contentView.topAnchor
                ),

            hostingController.view
                .bottomAnchor
                .constraint(
                    equalTo:
                        contentView.bottomAnchor
                )
        ])

        self.hostingController =
            hostingController
    }
}
