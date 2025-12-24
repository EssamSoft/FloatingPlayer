//
//  RootView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct RootView: View {

    // MARK: - Properties
    @State private var viewModel = AudioPlayerViewModel()
    @State private var selectedTab = 0

    // MARK: - Body
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)

                LibraryView(viewModel: viewModel)
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
                    .tag(1)

                SettingsView(viewModel: viewModel)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }

            // Floating player overlay - persists across all tabs
            FloatingAudioPlayerView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview
#Preview {
    RootView()
}
