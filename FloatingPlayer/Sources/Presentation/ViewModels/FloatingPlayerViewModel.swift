//
//  FloatingPlayerViewModel.swift
//  FloatingPlayer
//
//  Handles UI state and positioning logic
//

import SwiftUI
import Observation

@Observable
@MainActor
final class FloatingPlayerViewModel {
    // MARK: - Properties
    var isExpanded = false
    var position: CGPoint = .zero
    var isDragging = false

    private let config: PlayerConfiguration

    // MARK: - Initialization
    init(config: PlayerConfiguration) {
        self.config = config
    }

    // MARK: - Position Management
    func initializePosition(screenSize: CGSize, safeArea: EdgeInsets) {
        position = calculateInitialPosition(screenSize: screenSize, safeArea: safeArea)
    }

    func updatePosition(_ newPosition: CGPoint) {
        position = newPosition
    }

    func snapToCorner(screenSize: CGSize, safeArea: EdgeInsets) {
        let corners = calculateCorners(screenSize: screenSize, safeArea: safeArea)
        position = corners.min { $0.distance(to: position) < $1.distance(to: position) } ?? position
    }

    // MARK: - UI Actions
    func toggleExpanded() {
        isExpanded.toggle()
    }

    // MARK: - Private Helpers
    private func calculateInitialPosition(screenSize: CGSize, safeArea: EdgeInsets) -> CGPoint {
        CGPoint(
            x: screenSize.width - config.fab.margin - config.fab.size / 2,
            y: screenSize.height - config.fab.margin - config.fab.size / 2 - safeArea.bottom
        )
    }

    private func calculateCorners(screenSize: CGSize, safeArea: EdgeInsets) -> [CGPoint] {
        let halfSize = config.fab.size / 2
        let margin = config.fab.margin

        return [
            CGPoint(x: margin + halfSize, y: margin + halfSize + safeArea.top),
            CGPoint(x: screenSize.width - margin - halfSize, y: margin + halfSize + safeArea.top),
            CGPoint(x: margin + halfSize, y: screenSize.height - margin - halfSize - safeArea.bottom),
            CGPoint(x: screenSize.width - margin - halfSize, y: screenSize.height - margin - halfSize - safeArea.bottom)
        ]
    }
}

 
