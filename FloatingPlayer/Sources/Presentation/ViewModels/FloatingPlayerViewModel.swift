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
    init(config: PlayerConfiguration? = nil) {
        self.config = config ?? .default
    }

    // MARK: - Position Management
    func initializePosition(screenSize: CGSize, safeArea: EdgeInsets) {
        position = calculateInitialPosition(screenSize: screenSize, safeArea: safeArea)
    }

    func updatePosition(_ newPosition: CGPoint) {
        position = newPosition
    }

    /// Snaps to nearest corner based on current position
    func snapToCorner(screenSize: CGSize, safeArea: EdgeInsets) {
        let corner = GeometryHelper.detectCorner(
            position: position,
            screenSize: screenSize,
            safeArea: safeArea,
            config: config
        )
        
        position = GeometryHelper.position(
            for: corner,
            screenSize: screenSize,
            safeArea: safeArea,
            config: config
        )
    }
    
//    /// Snaps to corner based on drag direction (for drag gestures)
//    func snapToCornerByDirection(screenSize: CGSize, safeArea: EdgeInsets) {
//        let corner = GeometryHelper.detectCornerByDirection(
//            position: position,
//            screenSize: screenSize,
//            safeArea: safeArea,
//            config: config
//        )
//        
//        position = GeometryHelper.position(
//            for: corner,
//            screenSize: screenSize,
//            safeArea: safeArea,
//            config: config
//        )
//    }

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
}
