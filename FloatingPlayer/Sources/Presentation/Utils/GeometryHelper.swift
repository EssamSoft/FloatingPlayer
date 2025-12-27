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
    
    // ✅ NEW: Detect corner based on drag direction
    static func detectCornerByDirection(
        currentPosition: CGPoint,
        finalPosition: CGPoint,
        screenSize: CGSize,
        safeArea: EdgeInsets,
        config: PlayerConfiguration
    ) -> Corner {
        let deltaX = finalPosition.x - currentPosition.x
        let deltaY = finalPosition.y - currentPosition.y
        
        // ✅ Require minimum 30pt movement to change that direction
        let minThreshold: CGFloat = 30
        
        let shouldChangeHorizontal = abs(deltaX) > minThreshold
        let shouldChangeVertical = abs(deltaY) > minThreshold
        
        // Determine target position
        let centerX = screenSize.width / 2
        let centerY = screenSize.height / 2
        
        let targetRight: Bool
        let targetBottom: Bool
        
        if shouldChangeHorizontal {
            targetRight = deltaX > 0
        } else {
            targetRight = currentPosition.x > centerX // Keep current side
        }
        
        if shouldChangeVertical {
            targetBottom = deltaY > 0
        } else {
            targetBottom = currentPosition.y > centerY // Keep current side
        }
        
        switch (targetRight, targetBottom) {
        case (false, false): return .topLeft
        case (true, false): return .topRight
        case (false, true): return .bottomLeft
        case (true, true): return .bottomRight
        }
    }

    // ✅ NEW: Get position for a specific corner
    static func position(
        for corner: Corner,
        screenSize: CGSize,
        safeArea: EdgeInsets,
        config: PlayerConfiguration
    ) -> CGPoint {
        let positions = cornerPositions(screenSize: screenSize, safeArea: safeArea, config: config)
        return positions[Corner.allCases.firstIndex(of: corner) ?? 3]
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
