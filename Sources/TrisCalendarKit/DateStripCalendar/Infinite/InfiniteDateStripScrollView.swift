//
//  InfiniteDateStripScrollView.swift
//  TrisCalendarKit
//
//  Created by COMATOKI on 2026-09-17.
//

import SwiftUI
import UIKit

struct InfiniteDateStripScrollView: UIViewRepresentable {
    @Binding var displayedDate: Date
    @Binding var selectedDate: Date?

    let highlightedDates: Set<Date>
    let configuration: CalendarConfiguration
    let style: CalendarStyle
    let options: InfiniteDateStripCalendarOptions
    let onSelectDate: (Date) -> Void

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

        DispatchQueue.main.async {
            context.coordinator.scrollToCenter(
                animated: false
            )
        }

        return collectionView
    }

    func updateUIView(
        _ collectionView: UICollectionView,
        context: Context
    ) {
        context.coordinator.parent = self
        collectionView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
