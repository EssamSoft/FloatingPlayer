//
//  FloatingAudioPlayerView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct FloatingAudioPlayerView: View {

    // MARK: - Properties
    let viewModel: AudioPlayerViewModel

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if viewModel.isPlayerExpanded {
                    expandedPlayer
                } else {
                    minimizedPlayer(geometry: geometry)
                }
            }
            .animation(
                .spring(response: PlayerConstants.Animation.springResponse, dampingFraction: PlayerConstants.Animation.springDamping),
                value: viewModel.isPlayerExpanded
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Subviews
    private var expandedPlayer: some View {
        VStack {
            Spacer()
            DockedPlayerView(viewModel: viewModel)
        }
    }

    private func minimizedPlayer(geometry: GeometryProxy) -> some View {
        MinimizedPlayerView(
            viewModel: viewModel,
            screenSize: geometry.size,
            safeAreaInsets: geometry.safeAreaInsets
        )
        .transition(.zoomBlur)
        .onAppear {
            if viewModel.fabPosition == .zero {
                viewModel.initializeFABPosition(
                    screenSize: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets
                )
            }
        }
    }
}

// MARK: - Previews
#Preview("Expanded Player") {
    @Previewable @State var viewModel = AudioPlayerViewModel()
    viewModel.isPlayerExpanded = true
    viewModel.isFavorite = true

    return FloatingAudioPlayerView(viewModel: viewModel)
}

#Preview("Minimized Player") {
    @Previewable @State var viewModel = AudioPlayerViewModel()
    viewModel.isPlayerExpanded = false

    return FloatingAudioPlayerView(viewModel: viewModel)
}
