//
//  ExpandedPlayerView.swift
//  FloatingPlayer
//
//  Expanded/docked player UI
//

import SwiftUI

struct ExpandedPlayerView<Item: MediaItem>: View {
    let playerVM: PlayerViewModel<Item>
    let floatingVM: FloatingPlayerViewModel
    let config: PlayerConfiguration
    
    @State private var dragOffset: CGFloat = 0
    private let dragThreshold: CGFloat = 100
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    progressBar
                    playerControls
                    seekControls
                }
                .overlay(alignment: .top) {
                    // Visual indicator that this component is swappable
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.secondary)
                        .opacity(0.6)
                        .frame(width: 40, height: 4)
                        .padding(.top, 8)
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: config.ui.cornerRadius))
            .shadow(radius: config.ui.shadowRadius, y: -2)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .offset(y: max(0, dragOffset))
            .opacity(1 - min(dragOffset / (dragThreshold * 1.0), 0.95))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height > 0 {
                            dragOffset = gesture.translation.height
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.height > dragThreshold {
                            floatingVM.toggleExpanded()
                        }
                        dragOffset = 0
                    }
            )
            
        }
        
    }
    
    // MARK: - Subviews
    
    private var progressBar: some View {
        ProgressView(value: playerVM.progress)
            .progressViewStyle(.linear)
            .scaleEffect(y: 0.5)
            .frame(height: config.ui.progressBarHeight)
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
        Image(systemName: playerVM.currentItem?.artwork ?? "music.note")
            .font(.title)
            .foregroundStyle(.primary)
            .frame(width: 50, height: 50)
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var songInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(playerVM.currentItem?.title ?? "No Media")
                .font(.headline)
                .lineLimit(1)
            
            Text(playerVM.currentItem?.subtitle ?? "Unknown")
                .font(.caption)
                .foregroundStyle(.secondary)
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
        Button(action: playerVM.toggleFavorite) {
            Image(systemName: playerVM.isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(playerVM.isFavorite ? .red : .secondary)
        }
    }
    
    private var playPauseButton: some View {
        Button(action: playerVM.togglePlayback) {
            Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
                .foregroundStyle(.primary)
        }
    }
    
    private var dismissButton: some View {
        Button {
            floatingVM.toggleExpanded()
        } label: {
            Image(systemName: "chevron.down")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var seekControls: some View {
        HStack(spacing: 12) {
            skipButton(icon: "minus", action: playerVM.skipBackward)
            
            Slider(
                value: Binding(
                    get: { playerVM.progress },
                    set: { playerVM.seek(to: $0) }
                ),
                in: 0...1
            )
            
            skipButton(icon: "plus", action: playerVM.skipForward)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    private func skipButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(width: 32, height: 32)
                .background(.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }
}


#Preview {
    @Previewable @State var playerVM = PlayerViewModel(
        service: DefaultMediaPlayerService(initialItem: Song.sample)
    )
    @Previewable @State var floatingVM = FloatingPlayerViewModel(config: .default)
    
    return FloatingPlayerView(playerVM: playerVM, floatingVM: floatingVM)
}
