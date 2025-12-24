//
//  SettingsView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//  This is just demo settings

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties
    let viewModel: AudioPlayerViewModel
    @State private var notificationsEnabled = true
    @State private var autoPlay = false
    @State private var playbackQuality = 1

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                playerSection
                playbackSection
                appSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Sections
    private var playerSection: some View {
        Section("Player Status") {
            statusRow(
                icon: "music.note",
                label: "Current Song",
                value: viewModel.currentSong?.title ?? "None"
            )

            statusRow(
                icon: "person.fill",
                label: "Artist",
                value: viewModel.currentSong?.artist ?? "Unknown"
            )

            statusRow(
                icon: viewModel.isPlaying ? "play.circle.fill" : "pause.circle.fill",
                label: "Status",
                value: viewModel.isPlaying ? "Playing" : "Paused"
            )

            statusRow(
                icon: viewModel.isFavorite ? "heart.fill" : "heart",
                label: "Favorite",
                value: viewModel.isFavorite ? "Yes" : "No"
            )
        }
    }

    private var playbackSection: some View {
        Section("Playback Settings") {
            Toggle(isOn: $notificationsEnabled) {
                Label("Notifications", systemImage: "bell.fill")
            }

            Toggle(isOn: $autoPlay) {
                Label("Auto Play", systemImage: "play.circle.fill")
            }

            Picker("Quality", selection: $playbackQuality) {
                Text("Low").tag(0)
                Text("Medium").tag(1)
                Text("High").tag(2)
            }
            .pickerStyle(.segmented)

            HStack {
                Label("Skip Interval", systemImage: "forward.fill")
                Spacer()
                Text("\(Int(PlayerConstants.Playback.skipInterval))s")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var appSection: some View {
        Section("App Information") {
            infoRow(label: "Version", value: "1.0.0")
            infoRow(label: "Build", value: "100")
            infoRow(label: "Architecture", value: "Clean MVVM")

            Button {
                viewModel.showPlayer()
            } label: {
                HStack {
                    Image(systemName: "music.note.list")
                    Text("Show Player")
                    Spacer()
                }
            }
        }
    }

    // MARK: - Helper Views
    private func statusRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Label(label, systemImage: icon)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView(viewModel: AudioPlayerViewModel())
}
