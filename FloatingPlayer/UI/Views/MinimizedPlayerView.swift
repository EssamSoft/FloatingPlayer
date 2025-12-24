//
//  MinimizedPlayerView.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

struct MinimizedPlayerView: View {

    // MARK: - Properties
    let viewModel: AudioPlayerViewModel
    let screenSize: CGSize
    let safeAreaInsets: EdgeInsets

    @State private var dragOffset: CGSize = .zero
    @State private var isDragActive = false

    // MARK: - Body
    var body: some View {
        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: PlayerConstants.FAB.size, height: PlayerConstants.FAB.size)
            .background(.blue)
            .clipShape(Circle())
            .shadow(radius: isDragActive ? 12 : 8)
            .scaleEffect(isDragActive ? 1.1 : 1.0)
            .offset(dragOffset)
            .position(viewModel.fabPosition)
            .onTapGesture(perform: handleTap)
            .gesture(dragGesture)
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.3), value: isDragActive)
    }

    // MARK: - Gestures
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged(handleDragChanged)
            .onEnded(handleDragEnded)
    }

    // MARK: - Actions
    private func handleTap() {
        guard !viewModel.isDragging else { return }
        withAnimation(.spring(response: PlayerConstants.Animation.springResponse, dampingFraction: PlayerConstants.Animation.springDamping)) {
            viewModel.showPlayer()
        }
    }

    private func handleDragChanged(_ value: DragGesture.Value) {
        if !isDragActive {
            isDragActive = true
            viewModel.isDragging = true
        }
        dragOffset = value.translation
    }

    private func handleDragEnded(_ value: DragGesture.Value) {
        let threshold = PlayerConstants.FAB.dragThreshold
        let exceedsThreshold = abs(value.translation.width) > threshold || abs(value.translation.height) > threshold

        if exceedsThreshold {
            updatePosition(with: value.translation)
        } else {
            resetDragOffset()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isDragActive = false
            viewModel.isDragging = false
        }
    }

    private func updatePosition(with translation: CGSize) {
        let newPosition = CGPoint(
            x: viewModel.fabPosition.x + translation.width,
            y: viewModel.fabPosition.y + translation.height
        )
        viewModel.updateFABPosition(newPosition)
        dragOffset = .zero

        withAnimation(.spring(response: PlayerConstants.Animation.snapResponse, dampingFraction: PlayerConstants.Animation.snapDamping)) {
            viewModel.snapFABToCorner(screenSize: screenSize, safeAreaInsets: safeAreaInsets)
        }
    }

    private func resetDragOffset() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = .zero
        }
    }
}
