//
//  AudioPlayerService.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import Foundation
import Observation

protocol AudioPlayerServiceProtocol {
    var currentSong: Song? { get }
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }

    func play()
    func pause()
    func togglePlayback()
    func seek(to time: TimeInterval)
    func skipForward(_ seconds: TimeInterval)
    func skipBackward(_ seconds: TimeInterval)
}

@Observable
@MainActor
final class AudioPlayerService: AudioPlayerServiceProtocol {

    // MARK: - Properties
    var currentSong: Song?
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0

    // MARK: - Initialization
    nonisolated init(initialSong: Song? = nil) {
        self.currentSong = initialSong
    }

    // MARK: - Playback Control
    func play() {
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func togglePlayback() {
        isPlaying.toggle()
    }

    func seek(to time: TimeInterval) {
        guard let song = currentSong else { return }
        currentTime = min(max(time, 0), song.duration)
    }

    func skipForward(_ seconds: TimeInterval = 15) {
        seek(to: currentTime + seconds)
    }

    func skipBackward(_ seconds: TimeInterval = 15) {
        seek(to: currentTime - seconds)
    }
}
