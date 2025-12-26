//
//  MediaItem.swift
//  FloatingPlayer
//
//  Generic media protocol for reusable player
//

import Foundation

/// Protocol for any playable media item
protocol MediaItem: Identifiable, Equatable {
    var id: UUID { get }
    var title: String { get }
    var subtitle: String { get }
    var artwork: String { get }
    var duration: TimeInterval { get }
}

// MARK: - Default Implementation

struct GenericMedia: MediaItem {
    let id = UUID()
    let title: String
    let subtitle: String
    let artwork: String
    let duration: TimeInterval

    static let sample = GenericMedia(
        title: "Sample Media",
        subtitle: "Sample Artist",
        artwork: "music.note",
        duration: 240
    )
}

// MARK: - Song (Audio-specific implementation)

struct Song: MediaItem {
    let id = UUID()
    let title: String
    let artist: String
    let albumArt: String
    let duration: TimeInterval

    var subtitle: String { artist }
    var artwork: String { albumArt }

    static let sample = Song(
        title: "Sample Song",
        artist: "Sample Artist",
        albumArt: "music.note",
        duration: 240
    )
}
