//
//  PlayerViewModel.swift
//  FloatingPlayer
//
//  Handles playback logic and media state
//

import Foundation
import Observation

@Observable
@MainActor
final class PlayerViewModel<Item: MediaItem> {
    // MARK: - Properties
    private let service: any MediaPlayerService<Item>
    private let config: PlayerConfiguration

    var isFavorite = false

    // MARK: - Computed Properties
    var currentItem: Item? { service.currentItem }
    var isPlaying: Bool { service.isPlaying }
    var currentTime: TimeInterval { service.currentTime }

    var progress: Double {
        guard let item = currentItem, item.duration > 0 else { return 0 }
        return currentTime / item.duration
    }

    var formattedCurrentTime: String { currentTime.formatted }
    var formattedDuration: String { (currentItem?.duration ?? 0).formatted }
    var formattedRemaining: String { ((currentItem?.duration ?? 0) - currentTime).formatted }

    // MARK: - Initialization
    init(
        service: any MediaPlayerService<Item>,
        config: PlayerConfiguration? = nil
    ) {
        self.service = service
        self.config = config ?? .default
    }

    // MARK: - Actions
    func togglePlayback() { service.togglePlayback() }
    func toggleFavorite() { isFavorite.toggle() }

    func seek(to progress: Double) {
        guard let item = currentItem else { return }
        service.seek(to: progress * item.duration)
    }

    func skipForward() {
        service.skip(.forward, interval: config.playback.skipInterval)
    }

    func skipBackward() {
        service.skip(.backward, interval: config.playback.skipInterval)
    }
}

// MARK: - TimeInterval Extension

private extension TimeInterval {
    var formatted: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
