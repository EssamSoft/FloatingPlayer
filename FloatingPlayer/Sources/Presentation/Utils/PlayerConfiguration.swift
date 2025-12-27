//
//  PlayerConfiguration.swift
//  FloatingPlayer
//
//  Centralized configuration for easy customization
//

import SwiftUI

struct PlayerConfiguration: Sendable {
    
    // MARK: - Configuration Instance

    let fab: FAB
    let animation: Animation
    let playback: Playback
    let ui: UI
    let gestures: Gestures
    
    init(
        fab: FAB = .default,
        animation: Animation = .default,
        playback: Playback = .default,
        ui: UI = .default,
        gestures: Gestures = .default
    ) {
        self.fab = fab
        self.animation = animation
        self.playback = playback
        self.ui = ui
        self.gestures = gestures
    }
    
    static let `default` = PlayerConfiguration()

    
    // MARK: - FAB Configuration
    struct FAB: Sendable {
        let size: CGFloat
        let margin: CGFloat
        let dragThreshold: CGFloat
        let primaryColor: Color
        let secondaryColor: Color
        
        init(
            size: CGFloat = 56,
            margin: CGFloat = 20,
            dragThreshold: CGFloat = 15,
            primaryColor: Color = .blue,
            secondaryColor: Color = .indigo
        ) {
            self.size = size
            self.margin = margin
            self.dragThreshold = dragThreshold
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
        }
        
        static let `default` = FAB()
    }
    // MARK: - Animation Configuration
    struct Animation: Sendable {
        let springResponse: Double
        let springDamping: Double
        let snapResponse: Double
        let snapDamping: Double
        
        init(
            springResponse: Double = 0.6,
            springDamping: Double = 0.8,
            snapResponse: Double = 0.3,
            snapDamping: Double = 0.75
        ) {
            self.springResponse = springResponse
            self.springDamping = springDamping
            self.snapResponse = snapResponse
            self.snapDamping = snapDamping
        }
        
        static let `default` = Animation()
    }

    // MARK: - Playback Configuration
    struct Playback: Sendable {
        let skipInterval: TimeInterval
        
        init(skipInterval: TimeInterval = 15) {
            self.skipInterval = skipInterval
        }
        
        static let `default` = Playback()
    }

    // MARK: - UI Configuration
    struct UI: Sendable {
        // General
        let cornerRadius: CGFloat
        let shadowRadius: CGFloat
        let progressBarHeight: CGFloat
        let progressBarScaleY: CGFloat
        
        // Expanded view layout
        let expandedShadowOffsetY: CGFloat
        let expandedHorizontalPadding: CGFloat
        let expandedBottomPadding: CGFloat
        
        // Drag indicator
        let dragIndicatorWidth: CGFloat
        let dragIndicatorHeight: CGFloat
        let dragIndicatorCornerRadius: CGFloat
        let dragIndicatorOpacity: CGFloat
        let dragIndicatorTopPadding: CGFloat
        
        // Controls layout
        let controlsSpacing: CGFloat
        let controlsHorizontalPadding: CGFloat
        let controlsVerticalPadding: CGFloat
        
        // Artwork
        let artworkSize: CGFloat
        let artworkCornerRadius: CGFloat
        let artworkBackgroundOpacity: CGFloat
        
        // Song info
        let songInfoSpacing: CGFloat
        
        // Action buttons
        let actionButtonsSpacing: CGFloat
        
        // Seek controls
        let seekControlsSpacing: CGFloat
        let seekControlsHorizontalPadding: CGFloat
        let seekControlsBottomPadding: CGFloat
        
        // Skip buttons
        let skipButtonSize: CGFloat
        let skipButtonBackgroundOpacity: CGFloat
        
        init(
            cornerRadius: CGFloat = 16,
            shadowRadius: CGFloat = 8,
            progressBarHeight: CGFloat = 2,
            progressBarScaleY: CGFloat = 0.5,
            expandedShadowOffsetY: CGFloat = -2,
            expandedHorizontalPadding: CGFloat = 16,
            expandedBottomPadding: CGFloat = 16,
            dragIndicatorWidth: CGFloat = 40,
            dragIndicatorHeight: CGFloat = 4,
            dragIndicatorCornerRadius: CGFloat = 2,
            dragIndicatorOpacity: CGFloat = 0.6,
            dragIndicatorTopPadding: CGFloat = 8,
            controlsSpacing: CGFloat = 16,
            controlsHorizontalPadding: CGFloat = 16,
            controlsVerticalPadding: CGFloat = 12,
            artworkSize: CGFloat = 50,
            artworkCornerRadius: CGFloat = 8,
            artworkBackgroundOpacity: CGFloat = 0.2,
            songInfoSpacing: CGFloat = 2,
            actionButtonsSpacing: CGFloat = 20,
            seekControlsSpacing: CGFloat = 12,
            seekControlsHorizontalPadding: CGFloat = 16,
            seekControlsBottomPadding: CGFloat = 8,
            skipButtonSize: CGFloat = 32,
            skipButtonBackgroundOpacity: CGFloat = 0.2
        ) {
            self.cornerRadius = cornerRadius
            self.shadowRadius = shadowRadius
            self.progressBarHeight = progressBarHeight
            self.progressBarScaleY = progressBarScaleY
            self.expandedShadowOffsetY = expandedShadowOffsetY
            self.expandedHorizontalPadding = expandedHorizontalPadding
            self.expandedBottomPadding = expandedBottomPadding
            self.dragIndicatorWidth = dragIndicatorWidth
            self.dragIndicatorHeight = dragIndicatorHeight
            self.dragIndicatorCornerRadius = dragIndicatorCornerRadius
            self.dragIndicatorOpacity = dragIndicatorOpacity
            self.dragIndicatorTopPadding = dragIndicatorTopPadding
            self.controlsSpacing = controlsSpacing
            self.controlsHorizontalPadding = controlsHorizontalPadding
            self.controlsVerticalPadding = controlsVerticalPadding
            self.artworkSize = artworkSize
            self.artworkCornerRadius = artworkCornerRadius
            self.artworkBackgroundOpacity = artworkBackgroundOpacity
            self.songInfoSpacing = songInfoSpacing
            self.actionButtonsSpacing = actionButtonsSpacing
            self.seekControlsSpacing = seekControlsSpacing
            self.seekControlsHorizontalPadding = seekControlsHorizontalPadding
            self.seekControlsBottomPadding = seekControlsBottomPadding
            self.skipButtonSize = skipButtonSize
            self.skipButtonBackgroundOpacity = skipButtonBackgroundOpacity
        }
        
        static let `default` = UI()
    }
    
    // MARK: - Gestures Configuration
    struct Gestures: Sendable {
        let dragThreshold: CGFloat
        let upwardDragResistance: CGFloat
        let maxUpwardDragOffset: CGFloat
        let opacityFadeMultiplier: CGFloat
        let maxOpacityFade: CGFloat
        
        init(
            dragThreshold: CGFloat = 100,
            upwardDragResistance: CGFloat = 0.15,
            maxUpwardDragOffset: CGFloat = 20,
            opacityFadeMultiplier: CGFloat = 1.0,
            maxOpacityFade: CGFloat = 0.95
        ) {
            self.dragThreshold = dragThreshold
            self.upwardDragResistance = upwardDragResistance
            self.maxUpwardDragOffset = maxUpwardDragOffset
            self.opacityFadeMultiplier = opacityFadeMultiplier
            self.maxOpacityFade = maxOpacityFade
        }
        
        // Named presets
        static let `default` = Gestures()
        
    }


}
