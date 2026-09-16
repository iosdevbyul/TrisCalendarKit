//
//  InfiniteDateStripCoordinator.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import UIKit

extension InfiniteDateStripScrollView {
    final class Coordinator: NSObject {
        var parent: InfiniteDateStripScrollView

        weak var collectionView: UICollectionView?

        let itemCount = 1001
        let centerIndex = 500

        private var anchorDate: Date

        init(
            parent: InfiniteDateStripScrollView
        ) {
            self.parent = parent
            self.anchorDate = parent.displayedDate
        }

        func scrollToCenter(
            animated: Bool
        ) {
            guard let collectionView else {
                return
            }

            let indexPath = IndexPath(
                item: centerIndex,
                section: 0
            )

            collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: animated
            )
        }

        func date(
            for index: Int
        ) -> Date? {
            let calendar =
                parent.configuration.configuredCalendar

            let offset = index - centerIndex

            return calendar.date(
                byAdding: .day,
                value: offset,
                to: anchorDate
            )
        }
    }
}

extension InfiniteDateStripScrollView.Coordinator:
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        itemCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    InfiniteDateStripCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? InfiniteDateStripCollectionViewCell,
            let date = date(
                for: indexPath.item
            )
        else {
            return UICollectionViewCell()
        }

        cell.configure(
            date: date,
            calendar:
                parent.configuration.configuredCalendar,
            selectedDate: parent.selectedDate,
            highlightedDates: parent.highlightedDates,
            style: parent.style
        )

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let visibleCount = CGFloat(
            parent.options.visibleDayCount
        )

        return CGSize(
            width: collectionView.bounds.width / visibleCount,
            height: collectionView.bounds.height
        )
    }

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
        parent.displayedDate = date
        parent.onSelectDate(date)

        collectionView.reloadData()
    }
}
