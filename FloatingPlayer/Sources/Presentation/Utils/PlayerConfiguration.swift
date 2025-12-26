//
//  PlayerConfiguration.swift
//  FloatingPlayer
//
//  Centralized configuration for easy customization
//

import SwiftUI

struct PlayerConfiguration: Sendable {
    // MARK: - FAB Configuration
    struct FAB: Sendable {
        let size: CGFloat
        let margin: CGFloat
        let dragThreshold: CGFloat
        let primaryColor: Color
        let secondaryColor: Color

        static let `default` = FAB(
            size: 56,
            margin: 20,
            dragThreshold: 15,
            primaryColor: .blue,
            secondaryColor: .indigo
        )
    }

    // MARK: - Animation Configuration
    struct Animation: Sendable {
        let springResponse: Double
        let springDamping: Double
        let snapResponse: Double
        let snapDamping: Double

        static let `default` = Animation(
            springResponse: 0.6,
            springDamping: 0.8,
            snapResponse: 0.3,
            snapDamping: 0.75
        )
    }

    // MARK: - Playback Configuration
    struct Playback: Sendable {
        let skipInterval: TimeInterval

        static let `default` = Playback(skipInterval: 15)
    }

    // MARK: - UI Configuration
    struct UI: Sendable {
        let cornerRadius: CGFloat
        let shadowRadius: CGFloat
        let progressBarHeight: CGFloat

        static let `default` = UI(
            cornerRadius: 16,
            shadowRadius: 8,
            progressBarHeight: 2
        )
    }

    // MARK: - Configuration Instance
    let fab: FAB
    let animation: Animation
    let playback: Playback
    let ui: UI

    static let `default` = PlayerConfiguration(
        fab: .default,
        animation: .default,
        playback: .default,
        ui: .default
    )
}
