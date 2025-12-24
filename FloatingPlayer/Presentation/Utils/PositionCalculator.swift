//
//  PositionCalculator.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

enum PositionCalculator {

    static func initialFABPosition(
        screenSize: CGSize,
        safeAreaInsets: EdgeInsets
    ) -> CGPoint {
        CGPoint(
            x: screenSize.width - PlayerConstants.FAB.margin - PlayerConstants.FAB.size / 2,
            y: screenSize.height - PlayerConstants.FAB.margin - PlayerConstants.FAB.size / 2 - safeAreaInsets.bottom
        )
    }

    static func snapToNearestCorner(
        currentPosition: CGPoint,
        screenSize: CGSize,
        safeAreaInsets: EdgeInsets
    ) -> CGPoint {
        let corners = cornerPositions(screenSize: screenSize, safeAreaInsets: safeAreaInsets)

        return corners.min { corner1, corner2 in
            distance(from: currentPosition, to: corner1) < distance(from: currentPosition, to: corner2)
        } ?? corners.last ?? currentPosition
    }

    // MARK: - Private Helpers

    private static func cornerPositions(
        screenSize: CGSize,
        safeAreaInsets: EdgeInsets
    ) -> [CGPoint] {
        let halfSize = PlayerConstants.FAB.size / 2
        let margin = PlayerConstants.FAB.margin

        return [
            // Top left
            CGPoint(x: margin + halfSize, y: margin + halfSize + safeAreaInsets.top),
            // Top right
            CGPoint(x: screenSize.width - margin - halfSize, y: margin + halfSize + safeAreaInsets.top),
            // Bottom left
            CGPoint(x: margin + halfSize, y: screenSize.height - margin - halfSize - safeAreaInsets.bottom),
            // Bottom right
            CGPoint(x: screenSize.width - margin - halfSize, y: screenSize.height - margin - halfSize - safeAreaInsets.bottom)
        ]
    }

    private static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        hypot(point1.x - point2.x, point1.y - point2.y)
    }
}
