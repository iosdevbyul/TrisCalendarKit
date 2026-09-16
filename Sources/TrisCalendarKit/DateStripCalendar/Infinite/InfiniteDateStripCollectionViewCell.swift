//
//  InfiniteDateStripCollectionViewCell.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI
import UIKit

final class InfiniteDateStripCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "InfiniteDateStripCollectionViewCell"

    private var hostingController:
        UIHostingController<DateStripDayCell>?

    override func prepareForReuse() {
        super.prepareForReuse()

        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }

    func configure(
        date: Date,
        calendar: Calendar,
        selectedDate: Date?,
        highlightedDates: Set<Date>,
        style: CalendarStyle
    ) {
        hostingController?.view.removeFromSuperview()

        let day = CalendarDay(
            date: date,
            isCurrentMonth: true,
            isToday: calendar.isDateInToday(date)
        )

        let normalizedDate =
            calendar.startOfDay(for: date)

        let normalizedHighlightedDates = Set(
            highlightedDates.map {
                calendar.startOfDay(for: $0)
            }
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
            isHighlighted:
                normalizedHighlightedDates.contains(
                    normalizedDate
                ),
            style: style
        )

        let controller = UIHostingController(
            rootView: rootView
        )

        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            controller.view.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            controller.view.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            controller.view.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])

        hostingController = controller
    }
}
