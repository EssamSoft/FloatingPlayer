//
//  FloatingPlayerView.swift
//  FloatingPlayer
//
//  Generic floating player container
//

import SwiftUI

struct FloatingPlayerView<Item: MediaItem>: View {
    let playerVM: PlayerViewModel<Item>
    let floatingVM: FloatingPlayerViewModel
    let config: PlayerConfiguration

    @Namespace private var playerNamespace

    init(
        playerVM: PlayerViewModel<Item>,
        floatingVM: FloatingPlayerViewModel,
        config: PlayerConfiguration = .default
    ) {
        self.playerVM = playerVM
        self.floatingVM = floatingVM
        self.config = config
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if floatingVM.isExpanded {
                    ExpandedPlayerView(playerVM: playerVM, floatingVM: floatingVM, config: config)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                } else {
                    MinimizedView(
                        playerVM: playerVM,
                        floatingVM: floatingVM,
                        config: config,
                        geometry: geometry
                    )
                    .transition(.Blur)
                  
                    
                }
            }
            .animation(
                .spring(response: config.animation.springResponse, dampingFraction: config.animation.springDamping),
                value: floatingVM.isExpanded
            )
            
            .onAppear {
                if floatingVM.position == .zero {
                    floatingVM.initializePosition(screenSize: geometry.size, safeArea: geometry.safeAreaInsets)
                }
            }

        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var playerVM = PlayerViewModel(
        service: DefaultMediaPlayerService(initialItem: Song.sample)
    )
    @Previewable @State var floatingVM = FloatingPlayerViewModel(config: .default)

    return FloatingPlayerView(playerVM: playerVM, floatingVM: floatingVM)
}
