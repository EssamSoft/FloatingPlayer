//
//  AudioPlayerViewModel.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class AudioPlayerViewModel {

    // MARK: - UI State
    var isPlayerExpanded = false
    var isFavorite = false
    var fabPosition: CGPoint = .zero
    var isDragging = false

    // MARK: - Dependencies
    private let playerService: AudioPlayerServiceProtocol

    // MARK: - Computed Properties
    var currentSong: Song? { playerService.currentSong }
    var isPlaying: Bool { playerService.isPlaying }
    var currentTime: TimeInterval { playerService.currentTime }

    var progress: Double {
        guard let song = currentSong else { return 0 }
        return TimeFormatter.progress(current: currentTime, total: song.duration)
    }

    var formattedCurrentTime: String {
        TimeFormatter.format(currentTime)
    }

    var formattedDuration: String {
        guard let song = currentSong else { return "0:00" }
        return TimeFormatter.format(song.duration)
    }

    var formattedTimeRemaining: String {
        guard let song = currentSong else { return "0:00" }
        return TimeFormatter.formatRemaining(current: currentTime, total: song.duration)
    }

    // MARK: - Initialization
    init(playerService: AudioPlayerServiceProtocol = AudioPlayerService(initialSong: .sample)) {
        self.playerService = playerService
    }

    // MARK: - Player Actions
    func togglePlayback() {
        playerService.togglePlayback()
    }

    func seek(to progress: Double) {
        guard let song = currentSong else { return }
        playerService.seek(to: progress * song.duration)
    }

    func skipForward() {
        playerService.skipForward(PlayerConstants.Playback.skipInterval)
    }

    func skipBackward() {
        playerService.skipBackward(PlayerConstants.Playback.skipInterval)
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

    // MARK: - UI Actions
    func togglePlayer() {
        isPlayerExpanded.toggle()
    }
    func showPlayer() {
        isPlayerExpanded = true
    }

    func hidePlayer() {
        isPlayerExpanded = false
    }

    func updateFABPosition(_ position: CGPoint) {
        fabPosition = position
    }

    func initializeFABPosition(screenSize: CGSize, safeAreaInsets: EdgeInsets) {
        fabPosition = PositionCalculator.initialFABPosition(
            screenSize: screenSize,
            safeAreaInsets: safeAreaInsets
        )
    }

    func snapFABToCorner(screenSize: CGSize, safeAreaInsets: EdgeInsets) {
        fabPosition = PositionCalculator.snapToNearestCorner(
            currentPosition: fabPosition,
            screenSize: screenSize,
            safeAreaInsets: safeAreaInsets
        )
    }
}
