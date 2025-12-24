//
//  ContentView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties
    @State private var viewModel = AudioPlayerViewModel()

    // MARK: - Body
    var body: some View {
        ZStack {
            mainContent
            FloatingAudioPlayerView(viewModel: viewModel)
        }
    }

    // MARK: - Subviews
    private var mainContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Hello, world!")

            playbackButton
            showPlayerButton
        }
        .padding()
    }

    private var playbackButton: some View {
        Button(viewModel.isPlaying ? "Pause" : "Play") {
            viewModel.togglePlayback()
        }
    }

    private var showPlayerButton: some View {
        Button("Show/hide Audio Player") {
            viewModel.togglePlayer()
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
