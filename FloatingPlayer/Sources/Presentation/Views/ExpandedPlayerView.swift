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
                    dragIndicator
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: config.ui.cornerRadius))
            .shadow(radius: config.ui.shadowRadius, y: config.ui.expandedShadowOffsetY)
            .padding(.horizontal, config.ui.expandedHorizontalPadding)
            .padding(.bottom, config.ui.expandedBottomPadding)
            .offset(y: dragOffset)
            .opacity(1 - min(dragOffset / (config.gestures.dragThreshold * config.gestures.opacityFadeMultiplier), config.gestures.maxOpacityFade))
            .gesture(dragGesture)
        }
    }
    
    // MARK: - Gestures
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.translation.height > 0 {
                    // Downward drag - normal behavior
                    dragOffset = gesture.translation.height
                } else {
                    // Upward drag - limited resistance effect
                    dragOffset = max(
                        gesture.translation.height * config.gestures.upwardDragResistance,
                        -config.gestures.maxUpwardDragOffset
                    )
                }
            }
            .onEnded { gesture in
                if gesture.translation.height > config.gestures.dragThreshold {
                    floatingVM.toggleExpanded()
                }
                withAnimation(
                    .spring(
                        response: config.animation.springResponse,
                        dampingFraction: config.animation.springDamping
                    )
                ) {
                    dragOffset = 0
                }
            }
    }
    
    // MARK: - Subviews
    
    private var dragIndicator: some View {
        RoundedRectangle(cornerRadius: config.ui.dragIndicatorCornerRadius)
            .fill(.secondary)
            .opacity(config.ui.dragIndicatorOpacity)
            .frame(
                width: config.ui.dragIndicatorWidth,
                height: config.ui.dragIndicatorHeight
            )
            .padding(.top, config.ui.dragIndicatorTopPadding)
    }
    
    private var progressBar: some View {
        ProgressView(value: playerVM.progress)
            .progressViewStyle(.linear)
            .scaleEffect(y: config.ui.progressBarScaleY)
            .frame(height: config.ui.progressBarHeight)
    }
    
    private var playerControls: some View {
        HStack(spacing: config.ui.controlsSpacing) {
            albumArtwork
            songInfo
            Spacer()
            actionButtons
        }
        .padding(.horizontal, config.ui.controlsHorizontalPadding)
        .padding(.vertical, config.ui.controlsVerticalPadding)
    }
    
    private var albumArtwork: some View {
        Image(systemName: playerVM.currentItem?.artwork ?? "music.note")
            .font(.title)
            .foregroundStyle(.primary)
            .frame(
                width: config.ui.artworkSize,
                height: config.ui.artworkSize
            )
            .background(.gray.opacity(config.ui.artworkBackgroundOpacity))
            .clipShape(RoundedRectangle(cornerRadius: config.ui.artworkCornerRadius))
    }
    
    private var songInfo: some View {
        VStack(alignment: .leading, spacing: config.ui.songInfoSpacing) {
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
        HStack(spacing: config.ui.actionButtonsSpacing) {
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
        HStack(spacing: config.ui.seekControlsSpacing) {
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
        .padding(.horizontal, config.ui.seekControlsHorizontalPadding)
        .padding(.bottom, config.ui.seekControlsBottomPadding)
    }
    
    private func skipButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(
                    width: config.ui.skipButtonSize,
                    height: config.ui.skipButtonSize
                )
                .background(.gray.opacity(config.ui.skipButtonBackgroundOpacity))
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
