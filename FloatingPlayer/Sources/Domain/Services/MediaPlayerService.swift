//
//  MediaPlayerService.swift
//  FloatingPlayer
//
//  Generic media player service
//

import Foundation
import Observation

protocol MediaPlayerService<Item>: AnyObject {
    associatedtype Item: MediaItem

    var currentItem: Item? { get }
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }

    func play()
    func pause()
    func togglePlayback()
    func seek(to time: TimeInterval)
    func skip(_ direction: SkipDirection, interval: TimeInterval)
}

enum SkipDirection {
    case forward, backward
}

// MARK: - Default Implementation

@Observable
@MainActor
final class DefaultMediaPlayerService<Item: MediaItem>: MediaPlayerService {
    var currentItem: Item?
    var isPlaying = false
    var currentTime: TimeInterval = 0

    init(initialItem: Item? = nil) {
        self.currentItem = initialItem
    }

    func play() { isPlaying = true }
    func pause() { isPlaying = false }
    func togglePlayback() { isPlaying.toggle() }

    func seek(to time: TimeInterval) {
        guard let item = currentItem else { return }
        currentTime = min(max(time, 0), item.duration)
    }

    func skip(_ direction: SkipDirection, interval: TimeInterval) {
        let offset = direction == .forward ? interval : -interval
        seek(to: currentTime + offset)
    }
}
