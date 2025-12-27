//
//  ContentView.swift
//  FloatingPlayer
//
//  Main app view with integrated floating player
//

import SwiftUI

struct ContentView: View {
    // MARK: - ViewModels
    
    let configuration: PlayerConfiguration = PlayerConfiguration(
        gestures: .init(dragThreshold: 50)
    )
    
    @State private var floatingVM = FloatingPlayerViewModel()
    
    @State private var playerVM = PlayerViewModel(service: DefaultMediaPlayerService(initialItem: Song.sample))

    // MARK: - Body
    var body: some View {
        ZStack {
            mainContent

            FloatingPlayerView(
                playerVM: playerVM,
                floatingVM: floatingVM,
                config: configuration
                
            )
        }
    }

    // MARK: - Main Content
    private var mainContent: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    header
                    demoControls
                    mediaInfo
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Floating Player")
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)

            Text("Floating Player Demo")
                .font(.title2.bold())

            Text("Drag the floating button to reposition • Tap arrow to expand")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var demoControls: some View {
        VStack(spacing: 16) {
            Text("Quick Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                Button {
                    playerVM.togglePlayback()
                } label: {
                    Label(playerVM.isPlaying ? "Pause" : "Play", systemImage: playerVM.isPlaying ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    withAnimation {
                        floatingVM.toggleExpanded()
                    }
                } label: {
                    Label(floatingVM.isExpanded ? "Minimize" : "Expand", systemImage: floatingVM.isExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
 
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var mediaInfo: some View {
        VStack(spacing: 16) {
            Text("Now Playing")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                infoRow(label: "Title", value: playerVM.currentItem?.title ?? "N/A")
                infoRow(label: "Artist", value: playerVM.currentItem?.subtitle ?? "N/A")
                infoRow(label: "Duration", value: playerVM.formattedDuration)
                infoRow(label: "Current Time", value: playerVM.formattedCurrentTime)
                infoRow(label: "Remaining", value: playerVM.formattedRemaining)
                infoRow(label: "Progress", value: "\(Int(playerVM.progress * 100))%")
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
