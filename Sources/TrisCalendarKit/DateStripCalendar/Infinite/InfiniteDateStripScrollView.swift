//
//  InfiniteDateStripScrollView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI
import UIKit

@MainActor
struct InfiniteDateStripScrollView: UIViewRepresentable {

    @Binding var displayedDate: Date
    @Binding var selectedDate: Date?

    let highlightedDates: Set<Date>
    let configuration: CalendarConfiguration
    let style: CalendarStyle
    let options: InfiniteDateStripCalendarOptions
    let onSelectDate: (Date) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(
        context: Context
    ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .normal

        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator

        collectionView.register(
            InfiniteDateStripCollectionViewCell.self,
            forCellWithReuseIdentifier:
                InfiniteDateStripCollectionViewCell.reuseIdentifier
        )

        context.coordinator.collectionView = collectionView

        return collectionView
    }

    func updateUIView(
        _ collectionView: UICollectionView,
        context: Context
    ) {
        context.coordinator.parent = self

        collectionView.collectionViewLayout.invalidateLayout()

        context.coordinator.performInitialScrollIfNeeded(
            in: collectionView
        )

        context.coordinator.synchronizeDisplayedDateIfNeeded(
            in: collectionView
        )

        context.coordinator.updateVisibleStateIfNeeded(
            in: collectionView
        )
    }

    @MainActor
    final class Coordinator:
        NSObject,
        UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout {

        var parent: InfiniteDateStripScrollView

        weak var collectionView: UICollectionView?

        private let logic = InfiniteDateStripLogic()

        private var anchorDate: Date

        private var isRecentering = false
        private var didInitialScroll = false

        private var lastReportedDate: Date?
        private var lastSelectedDate: Date?

        private var normalizedHighlightedDates: Set<Date>
        private var lastNormalizedHighlightedDates: Set<Date>

        init(
            parent: InfiniteDateStripScrollView
        ) {
            self.parent = parent

            let calendar =
                parent.configuration.configuredCalendar

            self.anchorDate = calendar.startOfDay(
                for: parent.displayedDate
            )

            self.lastSelectedDate =
                parent.selectedDate

            let normalizedHighlights = Set(
                parent.highlightedDates.map {
                    calendar.startOfDay(
                        for: $0
                    )
                }
            )

            self.normalizedHighlightedDates =
                normalizedHighlights

            self.lastNormalizedHighlightedDates =
                normalizedHighlights

            super.init()
        }

        // MARK: - Initial Position

        func performInitialScrollIfNeeded(
            in collectionView: UICollectionView
        ) {
            guard !didInitialScroll else {
                return
            }

            guard
                collectionView.bounds.width > 0,
                collectionView.bounds.height > 0
            else {
                return
            }

            collectionView.layoutIfNeeded()

            let indexPath = IndexPath(
                item: logic.centerIndex,
                section: 0
            )

            collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )

            didInitialScroll = true
            lastReportedDate = anchorDate
        }
        
        func synchronizeDisplayedDateIfNeeded(
            in collectionView: UICollectionView
        ) {
            guard didInitialScroll else {
                return
            }

            let calendar =
                parent.configuration.configuredCalendar

            let targetDate = calendar.startOfDay(
                for: parent.displayedDate
            )

            if let lastReportedDate,
               calendar.isDate(
                   lastReportedDate,
                   inSameDayAs: targetDate
               ) {
                return
            }

            isRecentering = true

            anchorDate = targetDate

            collectionView.reloadData()
            collectionView.layoutIfNeeded()

            let centerIndexPath = IndexPath(
                item: logic.centerIndex,
                section: 0
            )

            collectionView.scrollToItem(
                at: centerIndexPath,
                at: .centeredHorizontally,
                animated: false
            )

            lastReportedDate = targetDate

            isRecentering = false
        }

        // MARK: - Date Calculation

        private func date(
            for index: Int
        ) -> Date? {
            logic.date(
                for: index,
                anchorDate: anchorDate,
                calendar: parent.configuration.configuredCalendar
            )
        }

        // MARK: - State Update

        func updateVisibleStateIfNeeded(
            in collectionView: UICollectionView
        ) {
            let calendar =
                parent.configuration.configuredCalendar

            let currentNormalizedHighlights = Set(
                parent.highlightedDates.map {
                    calendar.startOfDay(
                        for: $0
                    )
                }
            )

            let selectedDateChanged =
                lastSelectedDate
                != parent.selectedDate

            let highlightedDatesChanged =
                lastNormalizedHighlightedDates
                != currentNormalizedHighlights

            guard
                selectedDateChanged
                || highlightedDatesChanged
            else {
                return
            }

            lastSelectedDate =
                parent.selectedDate

            if highlightedDatesChanged {
                normalizedHighlightedDates =
                    currentNormalizedHighlights

                lastNormalizedHighlightedDates =
                    currentNormalizedHighlights
            }

            let visibleIndexPaths =
                collectionView.indexPathsForVisibleItems

            guard !visibleIndexPaths.isEmpty else {
                return
            }

            collectionView.reloadItems(
                at: visibleIndexPaths
            )
        }

        // MARK: - Center Tracking

        private func centeredIndexPath(
            in collectionView: UICollectionView
        ) -> IndexPath? {
            let visibleCenterX =
                collectionView.contentOffset.x
                + collectionView.bounds.width / 2

            let visibleCenter = CGPoint(
                x: visibleCenterX,
                y: collectionView.bounds.midY
            )

            if let indexPath =
                collectionView.indexPathForItem(
                    at: visibleCenter
                ) {
                return indexPath
            }

            let visibleRect = CGRect(
                origin: collectionView.contentOffset,
                size: collectionView.bounds.size
            )

            return collectionView
                .collectionViewLayout
                .layoutAttributesForElements(
                    in: visibleRect
                )?
                .min {
                    abs(
                        $0.center.x
                        - visibleCenterX
                    )
                    <
                    abs(
                        $1.center.x
                        - visibleCenterX
                    )
                }?
                .indexPath
        }

        private func reportCenteredDate(
            in collectionView: UICollectionView
        ) {
            guard
                didInitialScroll,
                !isRecentering,
                let indexPath = centeredIndexPath(
                    in: collectionView
                ),
                let date = date(
                    for: indexPath.item
                )
            else {
                return
            }

            let calendar =
                parent.configuration.configuredCalendar

            if let lastReportedDate,
               calendar.isDate(
                   lastReportedDate,
                   inSameDayAs: date
               ) {
                return
            }

            lastReportedDate = date

            guard !calendar.isDate(
                parent.displayedDate,
                inSameDayAs: date
            ) else {
                return
            }

            parent.displayedDate = date
        }

        // MARK: - Infinite Recentering

        private func recenterIfNeeded(
            in collectionView: UICollectionView
        ) {
            guard
                didInitialScroll,
                !isRecentering,
                let indexPath = centeredIndexPath(
                    in: collectionView
                )
            else {
                return
            }

            let index = indexPath.item

            guard logic.shouldRecenter(
                at: index
            ) else {
                return
            }

            guard let centeredDate = date(
                for: index
            ) else {
                return
            }

            let calendar =
                parent.configuration.configuredCalendar

            isRecentering = true

            anchorDate = calendar.startOfDay(
                for: centeredDate
            )

            collectionView.reloadData()
            collectionView.layoutIfNeeded()

            let centerIndexPath = IndexPath(
                item: logic.centerIndex,
                section: 0
            )

            collectionView.scrollToItem(
                at: centerIndexPath,
                at: .centeredHorizontally,
                animated: false
            )

            lastReportedDate = anchorDate

            isRecentering = false
        }

        // MARK: - UICollectionViewDataSource

        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            logic.itemCount
        }

        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            guard
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier:
                            InfiniteDateStripCollectionViewCell
                                .reuseIdentifier,
                        for: indexPath
                    )
                    as? InfiniteDateStripCollectionViewCell,
                let date = date(
                    for: indexPath.item
                )
            else {
                return UICollectionViewCell()
            }

            let calendar =
                parent.configuration.configuredCalendar

            let normalizedDate =
                calendar.startOfDay(
                    for: date
                )

            cell.configure(
                date: date,
                calendar: calendar,
                selectedDate: parent.selectedDate,
                isHighlighted:
                    normalizedHighlightedDates.contains(
                        normalizedDate
                    ),
                style: parent.style
            )

            return cell
        }

        // MARK: - UICollectionViewDelegateFlowLayout

        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout:
                UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let visibleDayCount = max(
                1,
                parent.options.visibleDayCount
            )

            let width =
                collectionView.bounds.width
                / CGFloat(visibleDayCount)

            return CGSize(
                width: width,
                height: collectionView.bounds.height
            )
        }

        // MARK: - Selection

        func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            guard let date = date(
                for: indexPath.item
            ) else {
                return
            }

            parent.selectedDate = date
            parent.onSelectDate(date)

            lastSelectedDate = date

            let visibleIndexPaths =
                collectionView.indexPathsForVisibleItems

            if !visibleIndexPaths.isEmpty {
                collectionView.reloadItems(
                    at: visibleIndexPaths
                )
            }
        }

        // MARK: - UIScrollViewDelegate

        func scrollViewDidScroll(
            _ scrollView: UIScrollView
        ) {
            guard
                let collectionView =
                    scrollView as? UICollectionView
            else {
                return
            }

            reportCenteredDate(
                in: collectionView
            )
        }

        func scrollViewDidEndDecelerating(
            _ scrollView: UIScrollView
        ) {
            guard
                let collectionView =
                    scrollView as? UICollectionView
            else {
                return
            }

            reportCenteredDate(
                in: collectionView
            )

            recenterIfNeeded(
                in: collectionView
            )
        }

        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            guard
                !decelerate,
                let collectionView =
                    scrollView as? UICollectionView
            else {
                return
            }

            reportCenteredDate(
                in: collectionView
            )

            recenterIfNeeded(
                in: collectionView
            )
        }
    }
}
