//
//  Song.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import Foundation

struct Song: Identifiable, Equatable {
    let id: UUID
    let title: String
    let artist: String
    let albumArt: String
    let duration: TimeInterval

    init(
        id: UUID = UUID(),
        title: String,
        artist: String,
        albumArt: String,
        duration: TimeInterval
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumArt = albumArt
        self.duration = duration
    }
}

// MARK: - Sample Data
extension Song {
    nonisolated static let sample = Song(
        title: "Sample Song",
        artist: "Sample Artist",
        albumArt: "music.note",
        duration: 240
    )
}
