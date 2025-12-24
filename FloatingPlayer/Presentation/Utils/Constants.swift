//
//  Constants.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import Foundation
import CoreGraphics

enum PlayerConstants {
    enum FAB {
        static let size: CGFloat = 56
        static let margin: CGFloat = 20
        static let dragThreshold: CGFloat = 15
    }

    enum Animation {
        static let springResponse: Double = 0.6
        static let springDamping: Double = 0.8
        static let snapResponse: Double = 0.3
        static let snapDamping: Double = 0.75
    }

    enum Playback {
        static let skipInterval: TimeInterval = 15
    }

    enum UI {
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 8
        static let progressBarHeight: CGFloat = 2
    }
}
