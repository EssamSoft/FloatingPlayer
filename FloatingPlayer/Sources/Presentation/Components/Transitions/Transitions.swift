//
//  Transitions.swift
//  FloatingPlayer
//
//  Custom view transitions
//

import SwiftUI

extension AnyTransition {
    static var Blur: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .blur),
            removal: .opacity.combined(with: .blur)
        )
    }

    private static var blur: AnyTransition {
        .modifier(
            active: BlurModifier(radius: 5),
            identity: BlurModifier(radius: 0)
        )
    }
}

private struct BlurModifier: ViewModifier {
    let radius: CGFloat

    func body(content: Content) -> some View {
        content.blur(radius: radius)
    }
}

 

#Preview {
    @Previewable @State var playerVM = PlayerViewModel(
        service: DefaultMediaPlayerService(initialItem: Song.sample)
    )
    @Previewable @State var floatingVM = FloatingPlayerViewModel(config: .default)

    return FloatingPlayerView(playerVM: playerVM, floatingVM: floatingVM)
}
