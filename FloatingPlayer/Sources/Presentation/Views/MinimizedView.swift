//
//  MinimizedView.swift
//  FloatingPlayer
//
//  Floating action button with drag support
//

import SwiftUI

struct MinimizedView<Item: MediaItem>: View {
    let playerVM: PlayerViewModel<Item>
    let floatingVM: FloatingPlayerViewModel
    let config: PlayerConfiguration
    let geometry: GeometryProxy
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragActive = false
    @State private var currentCorner: GeometryHelper.Corner = .bottomRight
    
    private var maximizeOffset: CGPoint {
        let offset = 24 + config.fab.size / 2
        let xOffset = [.topRight, .bottomRight].contains(currentCorner) ? -offset : offset
        return CGPoint(x: xOffset, y: 0)
    }
    
    var body: some View {
        ZStack {
            playPauseButton
            maximizeButton
                .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.3), value: isDragActive)
            
        }
        .offset(dragOffset)
        .position(floatingVM.position)
        .gesture(dragGesture)
        .onAppear { detectCorner() }
        .animation(.spring(response: 0.4, dampingFraction: 0.4), value: currentCorner)
        // ⚠️ Re-detect corner when geometry changes
        .onChange(of: geometry.size) { _, _ in
            detectCorner()
        }
        // ⚠️ Re-detect corner when position updates
        .onChange(of: floatingVM.position) { _, _ in
            detectCorner()
        }
        
    }
    
    // MARK: - Subviews
    
    private var playPauseButton: some View {
        Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: config.fab.size, height: config.fab.size)
            .background(config.fab.primaryColor)
            .clipShape(Circle())
            .shadow(radius: isDragActive ? 12 : 8)
            .scaleEffect(isDragActive ? 1.2 : 1.0)
            .onTapGesture(perform: playerVM.togglePlayback)
    }
    
    private var maximizeButton: some View {
        Image(systemName: "arrow.up")
            .font(.caption)
            .foregroundStyle(.white)
            .frame(width: config.fab.size - 22, height: config.fab.size - 22)
            .background(config.fab.secondaryColor)
            .clipShape(Circle())
            .shadow(radius: isDragActive ? 12 : 8)
            .scaleEffect(isDragActive ? 1.15 : 1.0)
            .offset(x: maximizeOffset.x, y: maximizeOffset.y)
            .onTapGesture(perform: handleMaximize)
    }
    
    // MARK: - Gestures
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                if !isDragActive {
                    isDragActive = true
                    floatingVM.isDragging = true
                }
                dragOffset = value.translation
            }
            .onEnded { value in
                let dragDistance = sqrt(
                    pow(value.translation.width, 2) +
                    pow(value.translation.height, 2)
                )
                
                let snapThreshold: CGFloat = 40
                
                if dragDistance > snapThreshold {
                    let finalPosition = CGPoint(
                        x: floatingVM.position.x + value.translation.width,
                        y: floatingVM.position.y + value.translation.height
                    )
                    
                    // ✅ Pass both current and final positions
                    let targetCorner = GeometryHelper.detectCornerByDirection(
                        currentPosition: floatingVM.position,  // ✅ NEW
                        finalPosition: finalPosition,
                        screenSize: geometry.size,
                        safeArea: geometry.safeAreaInsets,
                        config: config
                    )
                    
                    let targetPosition = GeometryHelper.position(
                        for: targetCorner,
                        screenSize: geometry.size,
                        safeArea: geometry.safeAreaInsets,
                        config: config
                    )
                    
                    withAnimation(.spring(response: config.animation.snapResponse, dampingFraction: config.animation.snapDamping)) {
                        dragOffset = .zero
                        floatingVM.updatePosition(targetPosition)
                        isDragActive = false
                        floatingVM.isDragging = false
                    }
                    
                } else {
                    withAnimation(.spring(response: config.animation.snapResponse, dampingFraction: config.animation.snapDamping)) {
                        dragOffset = .zero
                        isDragActive = false
                        floatingVM.isDragging = false
                    }
                }
                
               
            }
    }
    
    
    
    // MARK: - Actions
    
    private func handleMaximize() {
        guard !floatingVM.isDragging else { return }
        withAnimation(.spring(response: config.animation.springResponse, dampingFraction: config.animation.springDamping)) {
            floatingVM.toggleExpanded()
        }
        
        
    }
    
    private func detectCorner() {
        currentCorner = GeometryHelper.detectCorner(
            position: floatingVM.position,
            screenSize: geometry.size,
            safeArea: geometry.safeAreaInsets,
            config: config
        )
    }
}



#Preview {
    @Previewable @State var playerVM = PlayerViewModel(
        service: DefaultMediaPlayerService(initialItem: Song.sample)
    )
    @Previewable @State var floatingVM = FloatingPlayerViewModel(config: .default)
    
    return FloatingPlayerView(playerVM: playerVM, floatingVM: floatingVM)
}
