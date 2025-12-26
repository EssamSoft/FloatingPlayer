//
//  GeometryHelper.swift
//  FloatingPlayer
//
//  Consolidated geometry calculations
//

import SwiftUI

enum GeometryHelper {
    enum Corner: CaseIterable {
        case topLeft, topRight, bottomLeft, bottomRight

        var description: String {
            switch self {
            case .topLeft: "Top Left"
            case .topRight: "Top Right"
            case .bottomLeft: "Bottom Left"
            case .bottomRight: "Bottom Right"
            }
        }
    }

    static func detectCorner(
        position: CGPoint,
        screenSize: CGSize,
        safeArea: EdgeInsets,
        config: PlayerConfiguration
    ) -> Corner {
        let corners = cornerPositions(screenSize: screenSize, safeArea: safeArea, config: config)
        let distances = zip(Corner.allCases, corners).map { ($0, $1.distance(to: position)) }
        return distances.min { $0.1 < $1.1 }?.0 ?? .bottomRight
    }

    static func cornerPositions(
        screenSize: CGSize,
        safeArea: EdgeInsets,
        config: PlayerConfiguration
    ) -> [CGPoint] {
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

// MARK: - CGPoint Extension

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        hypot(x - point.x, y - point.y)
    }
}
