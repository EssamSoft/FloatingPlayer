//
//  DockedPlayerView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct DockedPlayerView: View {

    // MARK: - Properties
    let viewModel: AudioPlayerViewModel

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            progressBar
            playerControls
            seekControls
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: PlayerConstants.UI.cornerRadius))
        .shadow(radius: PlayerConstants.UI.shadowRadius, y: -2)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    // MARK: - Subviews
    private var progressBar: some View {
        ProgressView(value: viewModel.progress)
            .progressViewStyle(.linear)
            .scaleEffect(y: 0.5)
            .frame(height: PlayerConstants.UI.progressBarHeight)
    }

    private var playerControls: some View {
        HStack(spacing: 16) {
            albumArtwork
            songInfo
            Spacer()
            actionButtons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var albumArtwork: some View {
        Image(systemName: viewModel.currentSong?.albumArt ?? "music.note")
            .font(.title)
            .foregroundStyle(.primary)
            .frame(width: 50, height: 50)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var songInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.currentSong?.title ?? "No Song")
                .font(.headline)
                .lineLimit(1)

            HStack(spacing: 4) {
                Text(viewModel.currentSong?.artist ?? "Unknown Artist")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("•")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("4/4")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .lineLimit(1)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 20) {
            favoriteButton
            playPauseButton
            dismissButton
        }
    }

    private var favoriteButton: some View {
        Button(action: viewModel.toggleFavorite) {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(viewModel.isFavorite ? .red : .secondary)
        }
    }

    private var playPauseButton: some View {
        Button(action: viewModel.togglePlayback) {
            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
                .foregroundStyle(.primary)
        }
    }

    private var dismissButton: some View {
        Button(action: viewModel.hidePlayer) {
            Image(systemName: "chevron.down")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private var seekControls: some View {
        HStack(spacing: 12) {
            skipBackwardButton

            Slider(
                value: Binding(
                    get: { viewModel.progress },
                    set: { viewModel.seek(to: $0) }
                ),
                in: 0...1
            )

            skipForwardButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var skipBackwardButton: some View {
        Button(action: viewModel.skipBackward) {
            Image(systemName: "minus")
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }

    private var skipForwardButton: some View {
        Button(action: viewModel.skipForward) {
            Image(systemName: "plus")
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }
}
