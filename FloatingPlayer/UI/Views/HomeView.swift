//
//  HomeView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties
    let viewModel: AudioPlayerViewModel

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    playerControlsSection
                    songInfoSection
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }

    // MARK: - Subviews
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "music.note.house.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)

            Text("Music Player")
                .font(.title.bold())

            Text("Tab 1 - Home View")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }

    private var playerControlsSection: some View {
        VStack(spacing: 16) {
            Text("Player Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                controlButton(
                    title: viewModel.isPlaying ? "Pause" : "Play",
                    icon: viewModel.isPlaying ? "pause.fill" : "play.fill",
                    color: .blue
                ) {
                    viewModel.togglePlayback()
                }

                controlButton(
                    title: "Show Player",
                    icon: "music.note.list",
                    color: .green
                ) {
                    viewModel.showPlayer()
                }
            }
        }
        .padding(.top, 20)
    }

    private var songInfoSection: some View {
        VStack(spacing: 16) {
            Text("Now Playing")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                infoRow(label: "Song", value: viewModel.currentSong?.title ?? "No song")
                infoRow(label: "Artist", value: viewModel.currentSong?.artist ?? "Unknown")
                infoRow(label: "Duration", value: viewModel.formattedDuration)
                infoRow(label: "Status", value: viewModel.isPlaying ? "Playing" : "Paused")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func controlButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.gradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView(viewModel: AudioPlayerViewModel())
}
