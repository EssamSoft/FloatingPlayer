//
//  LibraryView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct LibraryView: View {

    // MARK: - Properties
    let viewModel: AudioPlayerViewModel

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    playbackInfoSection
                    quickActionsSection
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Library")
        }
    }

    // MARK: - Subviews
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.system(size: 60))
                .foregroundStyle(.purple.gradient)

            Text("Your Library")
                .font(.title.bold())

            Text("Tab 2 - Library View")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }

    private var playbackInfoSection: some View {
        VStack(spacing: 16) {
            Text("Playback Information")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                progressRow(
                    label: "Progress",
                    value: "\(Int(viewModel.progress * 100))%"
                )

                progressRow(
                    label: "Current Time",
                    value: viewModel.formattedCurrentTime
                )

                progressRow(
                    label: "Remaining",
                    value: viewModel.formattedTimeRemaining
                )

                progressRow(
                    label: "Player State",
                    value: viewModel.isPlayerExpanded ? "Expanded" : "Minimized"
                )
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var quickActionsSection: some View {
        VStack(spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                actionButton(
                    title: "Skip Forward 15s",
                    icon: "goforward.15",
                    color: .orange
                ) {
                    viewModel.skipForward()
                }

                actionButton(
                    title: "Skip Backward 15s",
                    icon: "gobackward.15",
                    color: .blue
                ) {
                    viewModel.skipBackward()
                }

                actionButton(
                    title: viewModel.isFavorite ? "Unfavorite" : "Favorite",
                    icon: viewModel.isFavorite ? "heart.fill" : "heart",
                    color: .red
                ) {
                    viewModel.toggleFavorite()
                }
            }
        }
    }

    private func progressRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundStyle(.purple)
        }
    }

    private func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.body.bold())
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding()
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Preview
#Preview {
    LibraryView(viewModel: AudioPlayerViewModel())
}
